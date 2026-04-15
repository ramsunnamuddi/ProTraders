package com.protrdrs.repository;

import org.springframework.stereotype.Repository;

import com.protrdrs.model.BinaryBonus;
import com.protrdrs.model.BinaryBonusResultDTO;
import com.protrdrs.model.TotalTeamDTO;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface BinaryBonusRepository extends JpaRepository<BinaryBonus, Long> {

    @Query(value = "SELECT bb.people_id AS peopleId, bb.descendant_id AS descendantId, u.customer_id AS customerId, bb.binary_position as binaryPosition, bb.binary_bonus as binaryBonus, bb.binary_status as binaryStatus"+
    				" FROM binary_bonus bb JOIN user_hierarchy uh ON bb.descendant_id = uh.descendant_id JOIN users u ON uh.descendant_id = u.people_id"+
    				" WHERE bb.people_id=:peopleId", nativeQuery = true)
    List<BinaryBonusResultDTO> findBinaryBonusWithCustomerId(@Param("peopleId") Long peopleId);
    
    @Query(value = "select u.customer_id as customerId,u.full_name as fullname,"+
    				" CASE WHEN uh.position = '1' THEN 'LEFT' WHEN uh.position = '2' THEN 'RIGHT' ELSE uh.position END  AS position "+
    				"  from user_hierarchy uh, users u where ancestor_id=:peopleId"+
    				" and uh.descendant_id = u.people_id and uh.ancestor_id <> uh.descendant_id"+
    				" order by position asc ,descendant_id ", nativeQuery = true)
    List<TotalTeamDTO> findTeamByAncestorId(@Param("peopleId") Long peopleId);
    
    
}
