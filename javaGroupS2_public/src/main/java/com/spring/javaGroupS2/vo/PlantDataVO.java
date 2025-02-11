package com.spring.javaGroupS2.vo;

import lombok.Data;

@Data
public class PlantDataVO {
	
	private int idx;
	private String plantName;
	private String scientificName;
	private String commonName;
	private String use;
	private String used;
	private String usablePart;
	private String option;
	private String status;
	private String owner;
	private String ownSite;
	private double maxTemp ;
	private double minTemp;
	private double maxHumidity;
	private double minHumidity;
	private double maxPH ;
	private double minPH;
	private String lightLevel;
	private String wateringAmount;
	private String wateringFrequency;
	private String plantIntro;
	private String dataType;
	private String postDate;
	
	private int newLabel;
	
	//
	private String dataPart;
	private String vegetables;
	private String mainPhoto;
	private String contentPhoto;
	private String optionPhoto;
	private String part;
	private String edible;
}
