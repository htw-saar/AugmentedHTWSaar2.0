package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;
/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.AbstractDao;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.Room;

import java.util.Set;

public class RoomImpl extends AbstractDao implements Room {

    private LocationImpl location;

    private String type;
    private Integer seatsTotal;


    private Set<TimeSlotImpl> schedule;

    private Set<EquipmentImpl> equipment;

    public LocationImpl getLocation() {
        return location;
    }

    public void setLocation(LocationImpl location) {
        this.location = location;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getSeatsTotal() {
        return seatsTotal;
    }

    public void setSeatsTotal(Integer seatsTotal) {
        this.seatsTotal = seatsTotal;
    }

    public Set<EquipmentImpl> getEquipment() {
        return equipment;
    }

    public void setEquipment(Set<EquipmentImpl> equipment) {
        this.equipment = equipment;
    }

    public Set<TimeSlotImpl> getSchedule() {
        return schedule;
    }

    public void setSchedule(Set<TimeSlotImpl> schedule) {
        this.schedule = schedule;
    }

    /*
    private Boolean blackboard;
    private Boolean flipchart;
    private Boolean beamer;
    private Boolean screen;
    private Boolean proffesorPC;
    private Boolean smartboard;
    private Boolean whiteboard;
    private Boolean overheard;
    private Boolean microfon;
    private Boolean vent; //Lüftung
    private Boolean airConditioner; //Klimaanlage
    */


    // SPÄTER MEHR

    /*
    Machen wir später rein

    private Integer seatsExamn;
    private Integer seatsLecture;
    private String seatsArrangement;
    private Boolean barier;
    private Boolean dimable;
    */

    /*
    Später implementieren wenn bekannt ist wie und was wir da brauchen

    private String specialties;
    private Date deactivatedSince;
    private Date deactivatedFrom;
    private String deactivatedReason;
    private Boolean publicRoom;
    */
}
