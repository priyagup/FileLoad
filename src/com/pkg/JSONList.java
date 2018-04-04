package com.pkg;

import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class JSONList {
	protected List<AirAssist> listAirAssist;
		public JSONList(){
		listAirAssist = new ArrayList<>();
	}
	
	protected void adddataToJson(String line) {
		String[] csvAttributes = line.split(",");
		AirAssist airAssistBean = new AirAssist();
		
		airAssistBean.setCe(Double.valueOf(csvAttributes[1]));
		airAssistBean.setOpacity(Double.valueOf(csvAttributes[2]));
		airAssistBean.setAirAssist(Double.valueOf(csvAttributes[3]));
		listAirAssist.add(airAssistBean);
	}

	protected TimeStampBean addTimeStampToJson(String[] csvAttributes) {
		String[] timeAttribites = csvAttributes[0].split(":");
		TimeStampBean timeStampBean = new TimeStampBean();
		timeStampBean.setHours(Integer.valueOf(timeAttribites[0]));
		timeStampBean.setMinutes(Integer.valueOf(timeAttribites[1]));
		return timeStampBean;
	}
	
	@Override
	public String toString() {
		Gson gson=new GsonBuilder().setPrettyPrinting().create();
        System.out.println(gson.toJson(listAirAssist));
		return gson.toJson(listAirAssist);
	}

}
