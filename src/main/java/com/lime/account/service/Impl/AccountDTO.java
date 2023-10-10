package com.lime.account.service.Impl;

public class AccountDTO {
	private int accountSeq;
	
	public int getAccountSeq() {
		return accountSeq;
	}
	public void setAccountSeq(int accountSeq) {
		this.accountSeq = accountSeq;
	}
	private String profitCost;
	private String bigGroup;
	private String middleGroup;
	private String smallGroup;
	private String comment1;
	private String comment;
	private Integer transactionMoney;
	private String transactionDate;
	
	public String getProfitCost() {
		return profitCost;
	}
	public void setProfitCost(String profitCost) {
		this.profitCost = profitCost;
	}
	public String getBigGroup() {
		return bigGroup;
	}
	public void setBigGroup(String bigGroup) {
		this.bigGroup = bigGroup;
	}
	public String getMiddleGroup() {
		return middleGroup;
	}
	public void setMiddleGroup(String middleGroup) {
		this.middleGroup = middleGroup;
	}
	public String getSmallGroup() {
		return smallGroup;
	}
	public void setSmallGroup(String smallGroup) {
		this.smallGroup = smallGroup;
	}
	public String getComment1() {
		return comment1;
	}
	public void setComment1(String comment1) {
		this.comment1 = comment1;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public Integer getTransactionMoney() {
		return transactionMoney;
	}
	public void setTransactionMoney(Integer transactionMoney) {
		this.transactionMoney = transactionMoney;
	}
	public String getTransactionDate() {
		return transactionDate;
	}
	public void setTransactionDate(String transactionDate) {
		this.transactionDate = transactionDate;
	}
}
