package com.protrdrs.model;

import java.util.ArrayList;
import java.util.List;

public class EnhancedTreeNode {
    private String id;
    private String name;
    private String joiningDate;
    private List<EnhancedTreeNode> children;
    public EnhancedTreeNode() {}

    public EnhancedTreeNode(String name, String joiningDate, String customerId) {
        this.id = customerId;
        this.name = name;
        this.joiningDate = joiningDate;
        this.children = new ArrayList<>();
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getJoiningDate() { return joiningDate; }
    public List<EnhancedTreeNode> getChildren() { return children; }
    
    public void addChild(EnhancedTreeNode child) { 
        children.add(child); 
    }

	@Override
	public String toString() {
		return "EnhancedTreeNode [id=" + id + ", name=" + name + ", joiningDate=" + joiningDate + ", children="
				+ children + "]";
	}
}