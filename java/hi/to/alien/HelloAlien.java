package hi.to.alien;

import android.app.Activity;
import android.widget.TextView;
import android.os.Bundle;
import android.util.Log;

import android.content.res.AssetManager;
import android.system.Os;
import android.system.ErrnoException;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class HelloAlien extends Activity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    TextView text = new TextView(this);
    Log.v("ALIEN", "Created text view :D");
    setupCore("libcore.so");
    text.setText(getAlien());
    setContentView(text);
  }
  public void setupCore(String coreName) {
    String corePath = getApplicationInfo().nativeLibraryDir;
    String coreFullName = corePath + "/" + coreName;
    File core = new File(corePath, coreName);
    if (core.exists()) {
      Log.v("ALIEN", "Core file is here: " +  coreFullName);
    } else {
      Log.v("ALIEN", "Core is lost! 0.0");
      return;
    }
    setCorePath(coreFullName);
    Log.v("ALIEN", "Core path is set to " + coreFullName + ", success!");
  }
  /* public void copyAsset(String assetName, String destination) {
    try {
      File core = new File(destination, assetName);
      if (core.exists()) {
        Log.v("ALIEN", "While copying asset: file is already here, abort");
        return;
      }
      AssetManager assetManager = getAssets();
      InputStream core_in = assetManager.open(assetName);
      OutputStream core_out = new FileOutputStream(core);
      byte[] buffer = new byte[1024];
      int read;
      Log.v("ALIEN", "Start copying asset [" + assetName + "] to [" + destination + "]");
      while((read = core_in.read(buffer)) != -1){
        core_out.write(buffer, 0, read);
      }
      core_in.close();
      core_out.flush();
      core_out.close();
      Log.v("ALIEN", "Done!");
    } catch(IOException e) {
      Log.e("ALIEN", "Failed to copy asset 0.0", e);
    }
  } */
  public native String getAlien();
  public static native void setCorePath(String name);
  static {
    System.loadLibrary("sbcl");
    System.loadLibrary("hello-alien");
  }
}
