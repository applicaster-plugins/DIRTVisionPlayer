package com.applicaster.plugin.player.dirtvision;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.applicaster.jwplayerplugin.JWPlayerActivity;

import java.util.Map;

public class DIRTVisionPlayerActivity extends JWPlayerActivity {

    static final String PLAYABLE_KEY = "playable";
    static final String LIVEURL_KEY = "live_url";

    public static void startPlayerActivity(Context context, Bundle bundle, Map<String, String> params) {
        Intent intent = new Intent(context, DIRTVisionPlayerActivity.class);
        intent.putExtras(bundle);
        context.startActivity(intent);
    }

}
