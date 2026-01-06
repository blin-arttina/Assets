package com.blindart.assetsalert;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;

public class SplashActivity extends Activity {

    private static final int SPLASH_DELAY_MS = 1200;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        ImageView splashImage = findViewById(R.id.splashImage);

        Animation fadeIn = AnimationUtils.loadAnimation(this, R.anim.fade_in);
        splashImage.startAnimation(fadeIn);

        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            Animation fadeOut = AnimationUtils.loadAnimation(this, R.anim.fade_out);
            splashImage.startAnimation(fadeOut);

            // Start main near the end of fade-out
            new Handler(Looper.getMainLooper()).postDelayed(() -> {
                Intent intent = new Intent(SplashActivity.this, MainActivity.class);
                startActivity(intent);
                overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
                finish();
            }, 250);

        }, SPLASH_DELAY_MS);
    }
}
