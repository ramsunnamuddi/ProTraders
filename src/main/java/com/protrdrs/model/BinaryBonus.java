package com.protrdrs.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "binary_bonus")
public class BinaryBonus {

    @Id
    private Long id;

    @Column(name = "people_id")
    private Long peopleId;

    @Column(name = "descendant_id")
    private Long descendantId;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPeopleId() {
        return peopleId;
    }

    public void setPeopleId(Long peopleId) {
        this.peopleId = peopleId;
    }

    public Long getDescendantId() {
        return descendantId;
    }

    public void setDescendantId(Long descendantId) {
        this.descendantId = descendantId;
    }
}

