package com.applicaster.plugin.player.dirtvision;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.applicaster.jwplayerplugin.JWPlayerActivity;
import com.applicaster.plugin_manager.playersmanager.Playable;

public class DIRTVisionPlayerActivity extends JWPlayerActivity {

    private static final String PLAYABLE_KEY = "playable";

    public static void startPlayerActivity(Context context, Playable playable) {
        Intent intent = new Intent(context, DIRTVisionPlayerActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable(DIRTVisionPlayerActivity.PLAYABLE_KEY, playable);
        intent.putExtras(bundle);
        context.startActivity(intent);
    }

}
