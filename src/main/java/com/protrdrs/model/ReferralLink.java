package com.protrdrs.model;

import jakarta.persistence.*;

@Entity
@Table(name = "referral_links")
public class ReferralLink {

    @Id
    private Long people_id;
    private String left_ref_link;
    private String right_ref_link;
    
	public Long getPeople_id() {
		return people_id;
	}
	public void setPeople_id(Long people_id) {
		this.people_id = people_id;
	}
	public String getLeft_ref_link() {
		return left_ref_link;
	}
	public void setLeft_ref_link(String left_ref_link) {
		this.left_ref_link = left_ref_link;
	}
	public String getRight_ref_link() {
		return right_ref_link;
	}
	public void setRight_ref_link(String right_ref_link) {
		this.right_ref_link = right_ref_link;
	}
	
    
    
}
