package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */
public class LocationImpl {
    String roomNumber;
    String floor;
    String building;
    String campus;

    public LocationImpl(String roomNumber, String floor, String building, String campus) {
        this.roomNumber = roomNumber;
        this.floor = floor;
        this.building = building;
        this.campus = campus;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getFloor() {
        return floor;
    }

    public void setFloor(String floor) {
        this.floor = floor;
    }

    public String getBuilding() {
        return building;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public String getCampus() {
        return campus;
    }

    public void setCampus(String campus) {
        this.campus = campus;
    }
}
