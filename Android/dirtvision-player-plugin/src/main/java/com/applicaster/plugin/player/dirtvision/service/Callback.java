package com.applicaster.plugin.player.dirtvision.service;

public interface Callback {
    void onResult(String result);

    void onError(Throwable error);
}
