package hi.to.alien;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import android.view.View;
import android.widget.Button;

import java.io.File;

public class HelloActivity extends Activity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    Button button = new Button(this);
    button.setText("Click to initialize lisp.");

    button.setOnClickListener(new View.OnClickListener() {
        private boolean initialized = false;
        public void onClick(View view) {
          if (!initialized) {
            initialized = true;
            System.loadLibrary("hello-alien");
            setupLisp("libcore.so");
            button.setText(getAlien());
          }
        }
      });

    setContentView(button);
  }

  public void setupLisp(String coreName) {
    String corePath = getApplicationInfo().nativeLibraryDir;
    String coreFullName = corePath + "/" + coreName;

    File core = new File(corePath, coreName);

    if (core.exists()) {
      Log.v("ALIEN", "Core file is at " +  coreFullName);
      initLisp(coreFullName);
      Log.v("ALIEN", "Lisp initialised by core " + coreFullName);
    } else {
      Log.v("ALIEN", "Core is lost! 0.0");
    }
  }

  public native void initLisp(String path);
  public native String getAlien();
}
