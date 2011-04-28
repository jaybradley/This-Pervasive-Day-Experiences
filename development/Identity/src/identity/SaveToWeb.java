package identity;

import com.sun.image.codec.jpeg.*;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import processing.core.PApplet;
import processing.core.PImage;



/**
savetoweb taken from http://wiki.processing.org/index.php?title=Saving_files_to_a_web-server
@author Yonas Sandbæk
*/


public class SaveToWeb {
	 
	ThisPervasiveDayIdentity parent;
	String url = "not set";
	
	public SaveToWeb(ThisPervasiveDayIdentity parent, String url) {

		this.parent = parent;
		this.url = url;
		
	}
	  
	void saveFileString(String title, String ext, String folder, String[] data, boolean popup) {
	  PApplet.println("SAVING File START");  
	  postData(title+"_"+PApplet.year()+PApplet.nf(PApplet.month(),2)+PApplet.nf(PApplet.day(),2)+"-"+PApplet.nf(PApplet.hour(),2)+PApplet.nf(PApplet.minute(),2)+PApplet.nf(PApplet.second(),2),ext,folder,PApplet.join(data,"\n").getBytes(),popup);
	  PApplet.println("SAVING File STOP");  
	  
	}
	 
	void saveFile(String title, String ext, String folder, byte[] data, boolean popup) {
	  PApplet.println("SAVING File START");  
	  postData(title+"_"+PApplet.year()+PApplet.nf(PApplet.month(),2)+PApplet.nf(PApplet.day(),2)+"-"+PApplet.nf(PApplet.hour(),2)+PApplet.nf(PApplet.minute(),2)+PApplet.nf(PApplet.second(),2),ext,folder,data,popup);
	  PApplet.println("SAVING File STOP");  
	}
	 
	// For saving a jpg, you have to use [[hacks:saveasjpg|this]] code.
	void saveJPG(String title, String folder, PImage src) {
	  PApplet.println("SAVING JPG START");  
	  postData(title+"_"+PApplet.year()+PApplet.nf(PApplet.month(),2)+PApplet.nf(PApplet.day(),2)+"-"+PApplet.nf(PApplet.hour(),2)+PApplet.nf(PApplet.minute(),2)+PApplet.nf(PApplet.second(),2),"jpg",folder,bufferImage(src),true);
	  PApplet.println("SAVING JPG STOP");  
	}
	 
	void postData(String title, String ext, String folder,  byte[] bytes, boolean popup) {
	  try{
	    URL u = new URL(url+"?title="+title+"&ext="+ext+"&folder="+folder);
	    PApplet.println("Posting data to URL: " + u);
	    URLConnection c = u.openConnection();
	    // post multipart data
	 
	    c.setDoOutput(true);
	    c.setDoInput(true);
	    c.setUseCaches(false);
	 
	    // set request headers
	    c.setRequestProperty("Content-Type", "multipart/form-data; boundary=AXi93A");
	 
	    // open a stream which can write to the url
	    DataOutputStream dstream = new DataOutputStream(c.getOutputStream());
	 
	    // write content to the server, begin with the tag that says a content element is comming
	    dstream.writeBytes("--AXi93A\r\n");
	 
	    // discribe the content
	    dstream.writeBytes("Content-Disposition: form-data; name=\"data\"; filename=\"whatever\" \r\nContent-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n");
	    dstream.write(bytes,0,bytes.length);
	 
	    // close the multipart form request
	    dstream.writeBytes("\r\n--AXi93A--\r\n\r\n");
	    dstream.flush();
	    dstream.close();
	 
	    // read the output from the URL
	    try{
	      BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
	      String sIn = in.readLine();
	      //boolean b = true;
	      while(sIn!=null){
	        if(sIn!=null){
	          //if(popup) if(sIn.substring(0,folder.length()).equals(folder)) parent.link(url+sIn, "_blank"); 
	          System.out.println(sIn);
	          
	        }
	        sIn = in.readLine();
	      }
	    }
	    catch(Exception e){
	      e.printStackTrace();
	    }
	  }
	 
	  catch(Exception e){ 
	    e.printStackTrace();
	  }
	}

	byte[] bufferImage(PImage srcimg) {
		  ByteArrayOutputStream out = new ByteArrayOutputStream();
		  BufferedImage img = new BufferedImage(srcimg.width, srcimg.height, 2);
		  img = (BufferedImage) parent.createImage(srcimg.width,srcimg.height);
		  for (int i = 0; i < srcimg.width; i++)
		    for (int j = 0; j < srcimg.height; j++)
		      img.setRGB(i, j, srcimg.pixels[j * srcimg.width + i]);
		  try {
		    JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
		    JPEGEncodeParam encpar = encoder.getDefaultJPEGEncodeParam(img);
		    encpar.setQuality(1, false);
		    encoder.setJPEGEncodeParam(encpar);
		    encoder.encode(img);
		  }
		  catch (FileNotFoundException e) {
		    System.out.println(e);
		  }
		  catch (IOException ioe) {
		    System.out.println(ioe);
		  }
		  return out.toByteArray();
		}
	
}