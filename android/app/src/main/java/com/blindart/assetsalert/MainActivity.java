package com.blindart.assetsalert;

import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView tv = new TextView(this);
        tv.setText("Assets Alert is running");
        tv.setTextSize(22f);
        tv.setPadding(40, 40, 40, 40);

        setContentView(tv);
    }
}
