package com.pkg;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.Gson;

/**
 * Servlet implementation class FileUpload
 */
@WebServlet("/FileUpload")
public class Fileload extends HttpServlet {
	private static final long serialVersionUID = 1L;
	String filePath = null; 
	private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
    String type = null;
    String starttime = null;
    String endtime = null;
    int start;
    int end;
    static double maxvalue =-1, minvalue =-1;
    static double currentvalue;
    static int maxcount = -1, mincount = -1;
 
    	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (!ServletFileUpload.isMultipartContent(request)) {
			type = request.getParameter("type");
			if(type==null)
				type="Dynamic";
			else
				type="Static";
			starttime = request.getParameter("starttime");
			endtime = request.getParameter("endtime");
			try {
				  SimpleDateFormat displayFormat = new SimpleDateFormat("HH:mm");
			      SimpleDateFormat parseFormat = new SimpleDateFormat("hh : mm a");
			      Date date = parseFormat.parse(starttime);
			      starttime = displayFormat.format(date);
			      date = parseFormat.parse(endtime);
			      endtime = displayFormat.format(date);
			} catch (ParseException e1) {
				e1.printStackTrace();
			}
			start = Integer.parseInt(starttime.split(":")[0])*60+Integer.parseInt(starttime.split(":")[1]);
			end = Integer.parseInt(endtime.split(":")[0])*60+Integer.parseInt(endtime.split(":")[1]);
			ArrayList<AirAssist> list= null;
            try {
				list= readCSVFile(filePath,start,end);
			} catch (Exception e) {
				e.printStackTrace();
			}
            String json = new Gson().toJson(list);
            request.setAttribute("type", type);
            request.setAttribute("json", json); 
            request.setAttribute("starttime", start);
        	request.setAttribute("endtime", end);
        	  request.setAttribute("maxcount", maxcount);
              request.setAttribute("mincount", mincount);
              System.out.print("maxcount" + maxcount);
              System.out.println(maxvalue);
         // redirects client to message page
            getServletContext().getRequestDispatcher("/Chart.jsp").forward(
                    request, response);
            return;
        }
        // configures upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // sets memory threshold - beyond which files are stored in disk
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // sets temporary location to store files
        //factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        ServletFileUpload upload = new ServletFileUpload(factory);
        // sets maximum size of upload file
        upload.setFileSizeMax(MAX_FILE_SIZE);
        // sets maximum size of request (include file + form data)
        upload.setSizeMax(MAX_REQUEST_SIZE);
        // constructs the directory path to store upload file
        // this path is relative to application's directory
        String uploadPath= getServletContext().getInitParameter("location");
        // creates the directory if it does not exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        try {
            // parses the request's content to extract file data
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(request);
            //storing uploaded file into c:\files location
            if (formItems != null && formItems.size() > 0) {
                // iterates over form's fields
                for (FileItem item : formItems) {
                    // processes only fields that are not form fields
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        // saves the file on disk
                        item.write(storeFile);
                        request.setAttribute("message",
                            "Upload has been done successfully!");
                    }
                }
            }
            
            //Retreived uploaded file
            ArrayList<AirAssist> list = readCSVFile(filePath,0,1440);
            String json = new Gson().toJson(list);
            //System.out.println("jsonList "+jsonList.toString());
            request.setAttribute("type", "Dynamic");
            request.setAttribute("json", json);
 
            
        } catch (Exception ex) {
        	ex.printStackTrace();
            request.setAttribute("message",
                    "There was an error: " + ex.getMessage());
        }
        // redirects client to message page
        getServletContext().getRequestDispatcher("/Chart.jsp").forward(
                request, response);
	}
	
	public static ArrayList<AirAssist> readCSVFile(String filepath,int start,int end)throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(filepath));
		ArrayList<AirAssist> list = new ArrayList<AirAssist>();
        String line = null;
        int givenTime = 0;
        int count = 0;
        while((line = br.readLine())!=null) {
        	
        	String[] csvAttributes = line.split(",");
        	givenTime = Integer.parseInt(csvAttributes[0].split(":")[0])*60+Integer.parseInt(csvAttributes[0].split(":")[1]);
        	String[] timeAttribites = csvAttributes[0].split(":");
        	
        	if(isTimeBetween(start, end, givenTime)){
	        	AirAssist airAssistBean = new AirAssist();
	        	airAssistBean.setYear(2017);
	        	airAssistBean.setMonth(12);
	        	airAssistBean.setDay(17);
	        	airAssistBean.setHour(Integer.parseInt(timeAttribites[0]));
	    		airAssistBean.setMinute(Integer.parseInt(timeAttribites[1]));
	    		airAssistBean.setCe(Double.parseDouble(csvAttributes[1]));
	    		airAssistBean.setOpacity(Double.parseDouble(csvAttributes[2]));
	    		airAssistBean.setAirAssist(Double.parseDouble(csvAttributes[3]));
	    		currentvalue = Double.parseDouble(csvAttributes[3]);
	    		if(maxvalue == -1 && maxcount == -1) {
	    			maxvalue = currentvalue;
	    			maxcount = count;
	    			
	    		}
	    		if(minvalue == -1 && mincount == -1) {
	    			minvalue = currentvalue;
	    			mincount = count;
	    		}
	    		if(currentvalue > maxvalue) {
	    			maxvalue = currentvalue;
	    			maxcount = count;
	    		}
	    		if(currentvalue < minvalue) {
	    			minvalue = currentvalue;
	    			mincount = count;

					
				}
	    		list.add(airAssistBean);
        	}
        	count++;
        }
        
        
        return list;
	}
	
	public static boolean isTimeBetween(int startTime,int endTime,int givenTime){
		if(givenTime>=startTime && givenTime<=endTime)
			return true;
		else
			return false;
	}

}