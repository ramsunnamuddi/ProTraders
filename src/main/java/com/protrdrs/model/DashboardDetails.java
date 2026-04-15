package com.protrdrs.model;

public class DashboardDetails {
    private String totalItems;
    private String totalDeposits;
    private int activeDirects;
    private String leftBusiness;
    private String rightBusiness;
    private String binaryBonus;
    private String leftBonus;
    private String rightBonus;
    private String totalRoiBonus;
    private String availableBalance;
    private String totalWithdrawals;
    private String leftReferralLink;
    private String rightReferralLink;
    
    
    public String getLeftReferralLink() {
		return leftReferralLink;
	}

	public void setLeftReferralLink(String leftReferralLink) {
		this.leftReferralLink = leftReferralLink;
	}

	public String getRightReferralLink() {
		return rightReferralLink;
	}

	public void setRightReferralLink(String rightReferralLink) {
		this.rightReferralLink = rightReferralLink;
	}

	// Getters and Setters
    public String getLeftBonus() {
        return leftBonus;
    }

    public void setLeftBonus(String leftBonus) {
        this.leftBonus = leftBonus;
    }
    
    public String getRightBonus() {
        return rightBonus;
    }

    public void setRightBonus(String rightBonus) {
        this.rightBonus = rightBonus;
    }

    public String getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(String totalItems) {
        this.totalItems = totalItems;
    }

    public String getTotalDeposits() {
        return totalDeposits;
    }

    public void setTotalDeposits(String totalDeposits) {
        this.totalDeposits = totalDeposits;
    }

    public int getActiveDirects() {
        return activeDirects;
    }

    public void setActiveDirects(int activeDirects) {
        this.activeDirects = activeDirects;
    }

    public String getLeftBusiness() {
        return leftBusiness;
    }

    public void setLeftBusiness(String leftBusiness) {
        this.leftBusiness = leftBusiness;
    }

    public String getRightBusiness() {
        return rightBusiness;
    }

    public void setRightBusiness(String rightBusiness) {
        this.rightBusiness = rightBusiness;
    }

    public String getBinaryBonus() {
        return binaryBonus;
    }

    public void setBinaryBonus(String binaryBonus) {
        this.binaryBonus = binaryBonus;
    }

    public String getTotalRoiBonus() {
        return totalRoiBonus;
    }

    public void setTotalRoiBonus(String totalRoiBonus) {
        this.totalRoiBonus = totalRoiBonus;
    }

    public String getAvailableBalance() {
        return availableBalance;
    }

    public void setAvailableBalance(String availableBalance) {
        this.availableBalance = availableBalance;
    }

    public String getTotalWithdrawals() {
        return totalWithdrawals;
    }

    public void setTotalWithdrawals(String totalWithdrawals) {
        this.totalWithdrawals = totalWithdrawals;
    }

	@Override
	public String toString() {
		return "DashboardDetails [totalItems=" + totalItems + ", totalDeposits=" + totalDeposits + ", activeDirects="
				+ activeDirects + ", leftBusiness=" + leftBusiness + ", rightBusiness=" + rightBusiness
				+ ", binaryBonus=" + binaryBonus + ", leftBonus=" + leftBonus + ", rightBonus=" + rightBonus
				+ ", totalRoiBonus=" + totalRoiBonus + ", availableBalance=" + availableBalance + ", totalWithdrawals="
				+ totalWithdrawals + ", leftReferralLink=" + leftReferralLink + ", rightReferralLink="
				+ rightReferralLink + "]";
	}
    
    
}
