package com.blindart.assetsalert;

import android.os.Bundle;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(40, 40, 40, 40);
        layout.setBackgroundColor(0xFF000000); // black background

        TextView title = new TextView(this);
        title.setText("Assets Alert");
        title.setTextSize(26);
        title.setTextColor(0xFFFFFFFF); // white text

        Button button = new Button(this);
        button.setText("Start");
        button.setTextSize(26);
        button.setTextColor(0xFFFFFFFF); // white text
        button.setBackgroundColor(0xFFB00020); // red button

        layout.addView(title);
        layout.addView(button);

        setContentView(layout);
    }
}
