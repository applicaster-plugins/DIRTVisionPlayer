package com.applicaster.plugin.player.dirtvision.sample

import android.os.Bundle
import android.support.v4.app.FragmentActivity
import android.view.View
import com.applicaster.model.APURLPlayable
import com.applicaster.plugin_manager.PluginManager
import com.applicaster.plugin_manager.login.LoginManager
import com.applicaster.plugin_manager.playersmanager.PlayerContract
import com.applicaster.plugin_manager.playersmanager.internal.PlayableType
import com.applicaster.plugin_manager.playersmanager.internal.PlayersManager
import com.applicaster.util.AppData
import com.applicaster.util.UrlSchemeUtil
import kotlinx.android.synthetic.main.activity_main.*

/**
 * This sample activity will create a player contract which will create an instance of your player
 * and pass it a sample playable item. From there you have options to launch full screen or attach
 * inline.
 * This is for testing your implementation against the Zapp plugin system.
 *
 *
 * Note: You must have your player plugin module in this project and the appropriate plugin
 * manifest
 * in the plugin_configurations.json
 */
class MainActivity : FragmentActivity(), View.OnClickListener {

    private lateinit var playerContract: PlayerContract
    private var inlineAttached = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        fullscreen_button.setOnClickListener(this)
        inline_button.setOnClickListener(this)

        LoginManager.getLoginPlugin().handlePluginScheme(this, emptyMap())
        //
        video_url.setText("http://199.203.217.171/xml_parsers/media/video/1.mp4")
        video_id.setText("1ee61c2e23e836e1dcfad630dae13258")
    }

    private fun prepareUserData() {
        if (auth_token.text.toString().isNotEmpty()) {
            LoginManager.getLoginPlugin().token = auth_token.text.toString()
        }
    }

    override fun onClick(view: View) {
        prepareUserData()
        // Mock playable item. Replace this with the playable item your player expects
        val playable = APURLPlayable(
            video_url.text.toString(),
            "Test video",
            "Test Video",
            video_id.text.toString()
        )
        // Player type should be left as default (covers the standard player as well as all plugin players)
        playable.setType(PlayableType.Default)
        // Player contract will get the instance of your plugin player and pass it the playable item
        playerContract = PlayersManager.getInstance().createPlayer(playable, this)

        when (view.id) {
            R.id.fullscreen_button -> launchFullscreen()
            R.id.inline_button -> toggleInline()
        }
    }

    /**
     * Mimics the functionality of launching a fullscreen player in the Zapp platform
     * This should not be modified
     */
    private fun launchFullscreen() {
        playerContract.playInFullscreen(null, UrlSchemeUtil.PLAYER_REQUEST_CODE, this)
    }

    /**
     * Mimics the functionality of adding or removing an inline player in the Zapp platform
     * This should not be modified
     */
    private fun toggleInline() {
        if (!inlineAttached) {
            inline_button.text = "Remove Inline"
            inlineAttached = true
            playerContract.attachInline(video_layout)
            playerContract.playInline(null)
        } else {
            inline_button.text = "Play Inline"
            inlineAttached = false
            playerContract.stopInline()
            playerContract.removeInline(video_layout)
        }
    }
}
