package com.blindart.assetsalert;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.BLACK);
        layout.setPadding(32, 32, 32, 32);

        TextView title = new TextView(this);
        title.setText("Assets Alert");
        title.setTextColor(Color.WHITE);
        title.setTextSize(26);

        Button button = new Button(this);
        button.setText("Continue");
        button.setTextSize(26);

        layout.addView(title);
        layout.addView(button);

        setContentView(layout);
    }
}
