package it.kokoko3k.jdsp4rp5

import android.content.Context
import android.os.Environment
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.FileWriter
import android.os.Build
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import android.widget.Toast

object ApkInstaller {

    private const val TAG = "ApkInstaller"

    fun installApkFromAssets(context: Context, assetFileName: String, subfolder: String? = null): Boolean {
        try {
            val inputStream = if (subfolder != null) {
                context.assets.open("$subfolder/$assetFileName")
            } else {
                context.assets.open(assetFileName)
            }

            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (!downloadsDir.exists() && !downloadsDir.mkdirs()) {
                Log.e(TAG, "Impossibile creare la directory Download")
                return false
            }

            val apkFile = File(downloadsDir, assetFileName)
            val outputStream = FileOutputStream(apkFile)

            inputStream.copyTo(outputStream)

            inputStream.close()
            outputStream.close()

            val intent = Intent(Intent.ACTION_VIEW)
            val apkUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", apkFile)
            } else {
                Uri.fromFile(apkFile)
            }
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // Importante per Android 7.0+
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) // Necessario se chiamato da un contesto non Activity

            context.startActivity(intent)

            return true
        } catch (e: IOException) {
            Log.e(TAG, "Errore durante l'installazione dell'APK", e)
            return false
        }
    }
}


fun getLogFile(context: Context): File? {
    val TAG = "LogUtil" // Definizione della variabile tag
    val dir = context.getExternalFilesDir(null)
    if (dir == null) {
        Log.d(TAG, "Impossibile ottenere la directory dei documenti")
        return null
    }

    if (!dir.exists() && !dir.mkdirs()) {
        Log.d(TAG, "Impossibile creare la directory dei documenti")
        return null
    }

    return File(dir, "lastlog.txt")
}

fun copyAssetFolderToFilesDir(context: Context, assetFolderPath: String) {
    try {
        val assetManager = context.assets

        // Ottieni la lista dei file e delle sottocartelle nella cartella assets specificata
        val assetFiles = assetManager.list(assetFolderPath) ?: return // Se la cartella non esiste, esci

        if (assetFiles.isEmpty()) {
            // È una cartella vuota, creala nella directory dell'app
            val targetDir = File(context.filesDir, assetFolderPath)
            targetDir.mkdirs()
            return
        }

        for (assetFileName in assetFiles) {
            val fullAssetPath = if (assetFolderPath.isEmpty()) assetFileName else "$assetFolderPath/$assetFileName"

            try {
                //Prova ad aprire il file. Se fallisce, significa che è una cartella.
                assetManager.open(fullAssetPath).use {
                    // È un file, copialo
                    val outFile = File(context.filesDir, fullAssetPath)
                    outFile.parentFile?.mkdirs() // Crea le directory parent
                    FileOutputStream(outFile).use { output -> it.copyTo(output) }
                }
            } catch (e: IOException) {
                // Gestisci il caso in cui è una sottocartella, richiamando ricorsivamente la funzione
                copyAssetFolderToFilesDir(context, fullAssetPath)
            }
        }
    } catch (e: IOException) {
        e.printStackTrace()
    }
}

object JdspUtils {

    private const val TAG = "JdspUtils"

    val subfolder = "whole"

    fun installJdsp(context:Context) {
        // extract assets/whole/ under applicazione/files/
        // which means into in context.filesDir
        var apkname = "JamesDSPManagerThePBone.apk"
        ApkInstaller.installApkFromAssets(context, apkname, "whole")
    }


    fun enableJdsp(context: Context) {
        // extract assets/whole/ under application/files/
        // which means into in context.filesDir
        copyAssetFolderToFilesDir(context, subfolder)

        // filespath is: /data/user/0/it.kokoko3k.jdsp4rp5/files/whole/
        val filespath = File(context.filesDir, subfolder).absolutePath.toString()

        // logpath is: /storage/emulated/0/app.name/files/lostlog.txt
        val logpath = getLogFile(context)

        var cmd = "sh " + filespath + "/support/subscripts/jdsp.setup.sh" + " " + filespath + " > " + logpath
        Log.d(TAG, "enabling jdsp with cmd= " + cmd)

        //execute it:
        val rootexec = RootExec() // get instance
        val result = rootexec.executeAsRoot(cmd)
    }

    fun disableJdsp(context: Context) {
        // extract assets/whole/ under applicazione/files/
        // which means into in context.filesDir
        val subfolder = "whole"
        copyAssetFolderToFilesDir(context, subfolder)

        // filespath is: /data/user/0/it.kokoko3k.jdsp4rp5/files/whole/
        val filespath = File(context.filesDir, subfolder).absolutePath.toString()

        // logpath is: /storage/emulated/0/app.name/files/lostlog.txt
        val logpath = getLogFile(context)

        var cmd = "sh " + filespath + "/support/subscripts/jdsp.cleanup.sh" + " " + filespath + " > " + logpath
        Log.d(TAG, "enabling jdsp with cmd= " + cmd)

        //execute it:
        val rootexec = RootExec() // get instance
        val result = rootexec.executeAsRoot(cmd)
    }
}