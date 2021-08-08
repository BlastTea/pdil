package com.example.pdil

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.database.Cursor
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.provider.DocumentsContract
import android.provider.OpenableColumns
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.*
import java.lang.Exception
import java.lang.NullPointerException
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "BlastTea.example.pdil"
    private lateinit var resultChannel: MethodChannel.Result

    private val TAG_OPEN_FOLDER = "openFolder"
    private val TAG_OPEN_FILE_AND_CACHE_IT = "openFileAndCacheIt"
    private val TAG_SHARE_FILE = "shareFile"
    private val TAG_GET_FILE_NAME = "getFileName"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            resultChannel = result
            when(call.method) {
                "openFolder" -> {
                    val initPath : String = call.argument<String>("initPath")!!
                    Log.d(TAG_OPEN_FOLDER, "initPath : $initPath")
                    openFolder(this.context, initPath)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openFolder(context: Context, path : String) {
//        var path: String = context.getExternalFilesDir("Download")!!.path
        val uri: Uri = Uri.parse(path)
        val intent: Intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.setDataAndType(uri, "*/*")
        intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false)

//        intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, uri)
        startActivityForResult(intent, 7)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val context = this.context
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            when (requestCode) {
                7 -> {
                    val pathInCache: String? = openFileAndCahcedIt(data?.data)
                    if (pathInCache != null) {
                        val isSuccessSharing: Boolean = shareFile(pathInCache)
                        if (isSuccessSharing) {
                            resultChannel.success("Success Sharing File")
                        } else {
                            resultChannel.error("UNAVAILABLE", "Cannot Share File", null)
                        }
                    } else {
                        resultChannel.error("UNAVAILABLE", "Cannot Cached File", null)
                    }
                }
            }
        } else {
            // if Result is not ok
        }
    }

    private fun openFileAndCahcedIt(uri: Uri?): String? {
        var path: String = this.context.cacheDir.absolutePath
        lateinit var fos: FileOutputStream
        if (uri == null) {
            resultChannel.error("UNAVAILABLE", "Uri Is Null", null)
        } else {
            path = this.context.cacheDir.absolutePath + "/get_battery/" + (getFileName(uri)
                    ?: Random().nextInt(100000).toString())
            val file: File = File(path)
            if (!file.exists()) {
                file.parentFile.mkdirs()
                try {
                    fos = FileOutputStream(path)
                    try {
                        val out: BufferedOutputStream = BufferedOutputStream(fos)
                        val input: InputStream? = this.context.contentResolver.openInputStream(uri)

                        val buffer: ByteArray = ByteArray(8192)
                        var len: Int = 0

                        len = input?.read(buffer) ?: 0
                        while (len ?: 1 >= 0) {
                            out.write(buffer, 0, len)
                            len = input?.read(buffer) ?: 0
                        }

                        out.flush()
                    } finally {
                        fos.fd.sync()
                    }
                } catch (e: Exception) {
                    try {

                    } catch (ioEx: IOException) {
                        Log.e(TAG_OPEN_FILE_AND_CACHE_IT, "Failed To Close File Streams : ${ioEx.message}", null)
                        return null
                    } catch (nullEx: NullPointerException) {
                        Log.e(TAG_OPEN_FILE_AND_CACHE_IT, "Failed To Close File Streams : ${nullEx.message}", null)
                        return null
                    }
                    Log.e(TAG_OPEN_FILE_AND_CACHE_IT, "Failed to retrieve path : ${e.message}", null)
                }
            }
            Log.d(TAG_OPEN_FILE_AND_CACHE_IT, "File loaded and cached at : $path")
        }
        return path
    }

    private fun getFileName(uri: Uri): String? {
        var result: String? = null

        try {
            if (uri.scheme.equals("content")) {
                var cursor: Cursor? = this.context.contentResolver.query(uri, arrayOf<String>(OpenableColumns.DISPLAY_NAME), null, null, null)
                try {
                    if (cursor != null && cursor.moveToFirst()) {
                        result = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME))
                    }
                } finally {
                    cursor?.close()
                }
            }
            if (result == null) {
                result = uri.path
                var cut: Int? = uri.path?.lastIndexOf('/')
                if (cut != -1) {
                    result = uri.path?.substring(cut!! + 1)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG_GET_FILE_NAME, "Failed to handle file name : ${e.toString()}")
        }
        return result
    }

    private fun shareFile(path : String): Boolean {
        try {
            val file : File = File(path)
            val fileUri : Uri = FileProvider.getUriForFile(this.context, this.context.applicationContext.packageName + ".provider", file)

            val intent: Intent = Intent(Intent.ACTION_SEND)
            intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            intent.type = "application/*"
            intent.putExtra(Intent.EXTRA_STREAM, fileUri)
            intent.putExtra(Intent.EXTRA_SUBJECT, "Sharing File...")
            intent.putExtra(Intent.EXTRA_TEXT, "Sharing File...")
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

            val chooserIntent: Intent = Intent.createChooser(intent, "Share File")
            chooserIntent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP
            chooserIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            this.context.startActivity(chooserIntent)
        } catch (ex: Exception) {
            Log.e(TAG_SHARE_FILE, "Error : ${ex.message}")
            return false
        } finally {
            return true
        }
    }
}
