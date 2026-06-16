package com.devlogs.pro.pakistan.independence.day.wallpapers

import android.content.Context
import android.content.SharedPreferences
import android.media.MediaPlayer
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder

class VideoLiveWallpaperService : WallpaperService() {
    override fun onCreateEngine(): Engine = VideoWallpaperEngine()

    inner class VideoWallpaperEngine : Engine() {
        private var mediaPlayer: MediaPlayer? = null

        override fun onSurfaceCreated(holder: SurfaceHolder) {
            super.onSurfaceCreated(holder)
            startPlayer(holder)
        }

        override fun onSurfaceDestroyed(holder: SurfaceHolder) {
            stopPlayer()
            super.onSurfaceDestroyed(holder)
        }

        override fun onVisibilityChanged(visible: Boolean) {
            super.onVisibilityChanged(visible)
            val player = mediaPlayer ?: return
            if (visible) {
                if (!player.isPlaying) {
                    player.start()
                }
            } else if (player.isPlaying) {
                    player.pause()
            }
        }

        override fun onDestroy() {
            stopPlayer()
            super.onDestroy()
        }

        private fun startPlayer(holder: SurfaceHolder) {
            stopPlayer()
            val path = getSource(this@VideoLiveWallpaperService.applicationContext) ?: return

            mediaPlayer = MediaPlayer().apply {
                setSurface(holder.surface)
                setDataSource(path)
                isLooping = true
                setVolume(0f, 0f)
                setOnPreparedListener { it.start() }
                prepareAsync()
            }
        }

        private fun stopPlayer() {
            mediaPlayer?.let { player ->
                runCatching {
                    if (player.isPlaying) {
                        player.stop()
                    }
                }
                player.reset()
                player.release()
            }
            mediaPlayer = null
        }
    }

    companion object {
        private const val prefsName = "live_wallpaper_prefs"
        private const val sourceKey = "video_source"

        fun setSource(context: Context, path: String) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            prefs.edit().putString(sourceKey, path).apply()
        }

        fun getSource(context: Context): String? {
            val prefs: SharedPreferences =
                context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            return prefs.getString(sourceKey, null)
        }
    }
}
