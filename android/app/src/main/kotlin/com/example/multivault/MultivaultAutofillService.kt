package com.example.multivault

import android.app.PendingIntent
import android.app.assist.AssistStructure
import android.content.Intent
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.*
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.O)
class MultivaultAutofillService : AutofillService() {

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        val structure = request.fillContexts.lastOrNull()?.structure ?: run {
            callback.onSuccess(null)
            return
        }

        // Find autofill fields
        val fields = parseStructure(structure)
        if (fields.usernameId == null && fields.passwordId == null) {
            callback.onSuccess(null)
            return
        }

        // Create an authentication intent that opens the app
        val authIntent = Intent(this, MainActivity::class.java).apply {
            putExtra("autofill_mode", true)
            putExtra("autofill_domain", fields.webDomain ?: fields.packageName)
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            1001,
            authIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Create a presentation for the autofill prompt
        val presentation = RemoteViews(packageName, android.R.layout.simple_list_item_1).apply {
            setTextViewText(android.R.id.text1, "Unlock MultiVault")
        }

        val responseBuilder = FillResponse.Builder()

        // Add an authentication dataset - user needs to unlock the app first
        val datasetBuilder = Dataset.Builder(presentation)

        fields.usernameId?.let {
            datasetBuilder.setValue(it, AutofillValue.forText(""), presentation)
        }
        fields.passwordId?.let {
            datasetBuilder.setValue(it, AutofillValue.forText(""), presentation)
        }

        datasetBuilder.setAuthentication(pendingIntent.intentSender)
        responseBuilder.addDataset(datasetBuilder.build())

        callback.onSuccess(responseBuilder.build())
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        // Not implementing save for now - users should add entries through the app
        callback.onSuccess()
    }

    private fun parseStructure(structure: AssistStructure): AutofillFields {
        val fields = AutofillFields()
        for (i in 0 until structure.windowNodeCount) {
            val windowNode = structure.getWindowNodeAt(i)
            traverseNode(windowNode.rootViewNode, fields)
        }
        return fields
    }

    private fun traverseNode(node: AssistStructure.ViewNode, fields: AutofillFields) {
        // Check web domain
        node.webDomain?.let { fields.webDomain = it }

        // Check package name for app identification
        node.idPackage?.let { fields.packageName = it }

        val autofillHints = node.autofillHints
        if (autofillHints != null && node.autofillId != null) {
            for (hint in autofillHints) {
                when (hint) {
                    android.view.View.AUTOFILL_HINT_USERNAME,
                    android.view.View.AUTOFILL_HINT_EMAIL_ADDRESS -> {
                        fields.usernameId = node.autofillId
                    }
                    android.view.View.AUTOFILL_HINT_PASSWORD -> {
                        fields.passwordId = node.autofillId
                    }
                }
            }
        }

        // Heuristic: check input type and hint text
        if (node.autofillId != null && autofillHints.isNullOrEmpty()) {
            val hint = node.hint?.lowercase() ?: ""
            val idEntry = node.idEntry?.lowercase() ?: ""

            if (hint.contains("user") || hint.contains("email") || hint.contains("login") ||
                idEntry.contains("user") || idEntry.contains("email") || idEntry.contains("login")
            ) {
                if (fields.usernameId == null) {
                    fields.usernameId = node.autofillId
                }
            } else if (hint.contains("pass") || idEntry.contains("pass")) {
                if (fields.passwordId == null) {
                    fields.passwordId = node.autofillId
                }
            }
        }

        // Recurse into children
        for (i in 0 until node.childCount) {
            traverseNode(node.getChildAt(i), fields)
        }
    }

    private data class AutofillFields(
        var usernameId: AutofillId? = null,
        var passwordId: AutofillId? = null,
        var webDomain: String? = null,
        var packageName: String? = null
    )
}
