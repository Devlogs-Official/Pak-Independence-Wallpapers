package com.devlogs.pro.pakistani_independence_wallpapers

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedInputStream
import java.io.File
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val channelName = "pakistani_independence_wallpapers/wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "applyWallpaper" -> {
                        val imageUrl = call.argument<String>("imageUrl").orEmpty()
                        val target = call.argument<String>("target") ?: "both"

                        if (imageUrl.isBlank()) {
                            result.error(
                                "INVALID_IMAGE_URL",
                                "Wallpaper image URL is missing.",
                                null,
                            )
                            return@setMethodCallHandler
                        }

                        thread {
                            try {
                                val connection = URL(imageUrl).openConnection() as HttpURLConnection
                                connection.connectTimeout = 15000
                                connection.readTimeout = 30000
                                connection.instanceFollowRedirects = true
                                connection.connect()

                                if (connection.responseCode !in 200..299) {
                                    connection.disconnect()
                                    Handler(Looper.getMainLooper()).post {
                                        result.error(
                                            "DOWNLOAD_FAILED",
                                            "Failed to download wallpaper.",
                                            null,
                                        )
                                    }
                                    return@thread
                                }

                                val stream = BufferedInputStream(connection.inputStream)
                                val bitmap = BitmapFactory.decodeStream(stream)
                                stream.close()
                                connection.disconnect()

                                if (bitmap == null) {
                                    Handler(Looper.getMainLooper()).post {
                                        result.error(
                                            "DECODE_FAILED",
                                            "Unable to decode wallpaper image.",
                                            null,
                                        )
                                    }
                                    return@thread
                                }

                                val manager = WallpaperManager.getInstance(applicationContext)
                                when (target) {
                                    "home" -> {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                            manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                                        } else {
                                            manager.setBitmap(bitmap)
                                        }
                                    }

                                    "lock" -> {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                            manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                                        } else {
                                            Handler(Looper.getMainLooper()).post {
                                                result.error(
                                                    "UNSUPPORTED",
                                                    "Lock screen apply needs Android 7.0+.",
                                                    null,
                                                )
                                            }
                                            return@thread
                                        }
                                    }

                                    else -> {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                            manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                                            manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                                        } else {
                                            manager.setBitmap(bitmap)
                                        }
                                    }
                                }

                                Handler(Looper.getMainLooper()).post {
                                    result.success("Wallpaper applied successfully.")
                                }
                            } catch (error: Exception) {
                                Handler(Looper.getMainLooper()).post {
                                    result.error(
                                        "APPLY_FAILED",
                                        error.localizedMessage ?: "Failed to apply wallpaper.",
                                        null,
                                    )
                                }
                            }
                        }
                    }

                    "applyLiveWallpaper" -> {
                        val videoUrl = call.argument<String>("videoUrl").orEmpty()
                        val id = call.argument<String>("id").orEmpty()
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN) {
                            result.error(
                                "UNSUPPORTED",
                                "Live wallpapers are not supported on this Android version.",
                                null,
                            )
                            return@setMethodCallHandler
                        }
                        if (videoUrl.isBlank() || id.isBlank()) {
                            result.error(
                                "INVALID_VIDEO_URL",
                                "Live wallpaper video URL is missing.",
                                null,
                            )
                            return@setMethodCallHandler
                        }

                        thread {
                            try {
                                val targetFile = File(filesDir, "live_wallpaper_$id.mp4")
                                val connection = URL(videoUrl).openConnection() as HttpURLConnection
                                connection.connectTimeout = 15000
                                connection.readTimeout = 30000
                                connection.instanceFollowRedirects = true
                                connection.connect()

                                if (connection.responseCode !in 200..299) {
                                    connection.disconnect()
                                    Handler(Looper.getMainLooper()).post {
                                        result.error(
                                            "DOWNLOAD_FAILED",
                                            "Failed to download live wallpaper.",
                                            null,
                                        )
                                    }
                                    return@thread
                                }

                                connection.inputStream.use { input ->
                                    FileOutputStream(targetFile).use { output ->
                                        input.copyTo(output)
                                    }
                                }
                                connection.disconnect()

                                VideoLiveWallpaperService.setSource(
                                    applicationContext,
                                    targetFile.absolutePath,
                                )

                                val intent = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER).apply {
                                    putExtra(
                                        WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                                        ComponentName(
                                            this@MainActivity,
                                            VideoLiveWallpaperService::class.java,
                                        ),
                                    )
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }

                                Handler(Looper.getMainLooper()).post {
                                    startActivity(intent)
                                    result.success("Live wallpaper downloaded. Choose Set wallpaper on the next screen.")
                                }
                            } catch (error: Exception) {
                                Handler(Looper.getMainLooper()).post {
                                    result.error(
                                        "DOWNLOAD_FAILED",
                                        error.localizedMessage ?: "Failed to download live wallpaper.",
                                        null,
                                    )
                                }
                            }
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
