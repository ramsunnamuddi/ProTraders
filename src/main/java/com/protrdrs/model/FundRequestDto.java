package com.protrdrs.model;

public class FundRequestDto {
	    private Double amount;

		public Double getAmount() {
			return amount;
		}

		public void setAmount(Double amount) {
			this.amount = amount;
		}

		@Override
		public String toString() {
			return "FundRequestDto [amount=" + amount + "]";
		}
}
