package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model.RequestBody;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model.Room;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.RequestInterceptor.AuthenticationRequestInterceptor;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.EquipmentImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.LocationImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.RoomImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.TimeSlotImpl;
import feign.Feign;
import feign.RequestInterceptor;
import feign.codec.Decoder;
import feign.codec.Encoder;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Implements the functions defined by RoomServiceApiInterface
 */
public class RoomServiceApi implements Loggable {

    private final static String RAUMNUMMER = "raumnr";
    private final static String RAUMSTANDORT = "standort";
    private final static String RAUMGEBAEUDE = "gebaeude";
    private final static String RAUMETAGE = "etage";
    private final static String SITZPLAETZEVORLESUNG = "sitzplaetzevl";

    private RoomServiceApiInterface apiClient;

    /**
     * TODO
     * Konstruktor für die Klasse RoomServiceApi
     *
     * @param baseUri
     * @param apiToken
     * @param encoder
     * @param decoder
     * @param requestInterceptorList
     */
    public RoomServiceApi(String baseUri, String apiToken, Encoder encoder, Decoder decoder, List<RequestInterceptor> requestInterceptorList) {
        requestInterceptorList.add(new AuthenticationRequestInterceptor(apiToken));
        apiClient = Feign.builder()
                .decoder(decoder)
                .encoder(encoder)
                .requestInterceptors(requestInterceptorList)
                .target(RoomServiceApiInterface.class, baseUri);
    }

    /**
     * TODO
     *
     * @return
     */
    public RoomServiceApiInterface getApiClient() {
        return apiClient;
    }

    /**
     * Bucht einen Raum im Raumservice der HTW des Saarlandes
     *
     * @param key   API Key des HTW Raumservices
     * @param id    Raumnummer
     * @param date  Datum der Buchung
     * @param from  Uhrzeit von
     * @param to    Uhrzeit bis
     * @param event Grund/Veranstaltung für die Buchung
     * @param user  Authorisierter Nutzer der HTW
     * @return RequestBody mit dem Status der REST abfrage
     */
    public RequestBody<Object> bookRoom(String key, String id, String date, String from, String to, String event, String user) {
        RequestBody<Object> tempbody = apiClient.bookRoom(Map.of("key", key, "room", id, "date", date,
                "from", from, "to", to, "event", event, "user", user));
        debug("--> bookroom --> RequestBody: {} succes?: {}", tempbody, tempbody.getSuccess());
        return tempbody;
    }

    /**
     * Storniert eine Reservierung im Raumservice der HTW
     *
     * @param key  API Key des HTW Raumservices
     * @param id   Raumnummer
     * @param date Datum der Buchung
     * @param from Uhrzeit von
     * @param to   Uhrzeit bis
     * @param user Authorisierter Nutzer der HTW
     * @return RequestBody mit dem Status der REST abfrage
     */

    public RequestBody<Object> cancelReservation(String key, String id, String date, String from, String to, String user) {
        RequestBody<Object> tempbody = apiClient.cancelReservation(Map.of("key", key, "room", id, "date", date,
                "from", from, "to", to, "user", user));
        debug("--> cancelReservation --> RequestBody: {} succes?: {}", tempbody, tempbody.getSuccess());
        return tempbody;
    }

    /**
     * Abfragen von Informationen über einen Raum
     *
     * @param id       Raumnummer
     * @param date_beg Starttag
     * @param date_end Endtag
     * @return Liefert den Raum samt Informationen über die Ausstattung sowie den Buchungsplan im angegebenen Zeitraum
     * @throws Exception
     */

    public RoomImpl getRoom(String id, String date_beg, String date_end) throws Exception {
        RoomImpl roomImpl = new RoomImpl();
        RequestBody<List<Room>> tempbody = apiClient.getRoom(
                Map.of("room", id, "date_beg", date_beg, "date_end", date_end));
        debug("Received upstream data {}", tempbody);
        if (tempbody == null)
            return null;
        if (tempbody.getRecordset() == null)
            return null;
        List<Room> roomList = tempbody.getRecordset();
        if (roomList.size() == 0)
            return null;
        Room tempRoomForBasicInformations = roomList.get(0);
        if (tempRoomForBasicInformations == null)
            return null;
        debug("tempRoomForBasicInformations --->  {}", tempRoomForBasicInformations);
        //Ausstattung
        Set<EquipmentImpl> equipment = makeEquipment(tempRoomForBasicInformations.getAusstattung());
        //Location
        LocationImpl location = new LocationImpl((getElementfromSet(RAUMNUMMER, equipment)), (getElementfromSet(RAUMETAGE, equipment)), ((getElementfromSet(RAUMGEBAEUDE, equipment))), getElementfromSet(RAUMSTANDORT, equipment));
        //Timeslot
        HashSet<TimeSlotImpl> timeSlots = fillTimeSlots(tempbody);
        //Raum befüllen
        roomImpl.setId(tempRoomForBasicInformations.getRaumnr());
        roomImpl.setSeatsTotal(Integer.parseInt(getElementfromSet(SITZPLAETZEVORLESUNG, equipment)));
        roomImpl.setEquipment(equipment);
        roomImpl.setLocation(location);
        roomImpl.setSchedule(timeSlots);

        return roomImpl;
    }

    /**
     * Methode zum befüllen der Ausstattung eines Raumes.
     *
     * @param map
     * @return Set mit der Ausstattung
     */
    private Set makeEquipment(Map<String, Object> map) {
        Set<EquipmentImpl> set = new HashSet<>();
        EquipmentImpl tempEquipment;
        Iterator<Map.Entry<String, Object>> it = map.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, Object> pair = it.next();
            if (pair.getValue() != "0" && pair.getValue() != null) {
                tempEquipment = new EquipmentImpl(pair.getKey(), true);
                tempEquipment.setDetails((String) pair.getValue());
            } else {
                pair.setValue("0");
                tempEquipment = new EquipmentImpl(pair.getKey(), false);
                tempEquipment.setDetails("0");
            }
            set.add(tempEquipment);
        }
        return set;
    }

    /**
     * Holt einen Eintrag aus einem Set
     *
     * @param string zu bekommender Eintrag
     * @param set    zu durchsuchendes Set
     * @return gefundener Eintrag
     */
    private String getElementfromSet(String string, Set<EquipmentImpl> set) {
        for (EquipmentImpl obj : set) {
            if (obj.getName().equals(string))
                return obj.getDetails();
        }
        return null;
    }

    /**
     * Befüllt die Timeslots für die Rauminformationen
     *
     * @param body Requestbody mit den umzuformenden Buchungen
     * @return Liefert ein Hashset mit den gebuchten Events für einen Raum
     * @throws Exception
     */
    private HashSet<TimeSlotImpl> fillTimeSlots(RequestBody body) throws Exception {
        HashSet<TimeSlotImpl> timeSlots = new HashSet<>();
        SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        TimeSlotImpl timeslot;
        Boolean isNotBooked;
        debug("Received {} records", ((List) body.getRecordset()).size());

        /*
        body.getRecordset().stream().forEach(x -> {
            TimeSlotImpl t = new TimeSlotImpl();
            try {
                t.setFrom( dateFormater.parse(x.getDatum() + " " + x.getVon()) );
                t.setTo( dateFormater.parse(x.getDatum() + " " + x.getBis()) );
                t.setLabel( x.getVeranstaltung() );
            } catch (ParseException e) {
                error(e);
            }

            if (!timeSlots.contains(t))
                timeSlots.add(t);
        });
 */
        List<Room> htwRoomBookings = (List<Room>) body.getRecordset();
        for (Room temproom : htwRoomBookings) {
            String dateString = temproom.getDatum();
            String fromString = temproom.getVon();
            String toString = temproom.getBis();
            String beginStringhelper = dateString + " " + fromString;
            String endstringhelper = dateString + " " + toString;
            Date begin = dateFormater.parse(beginStringhelper);
            Date end = dateFormater.parse(endstringhelper);
            timeslot = new TimeSlotImpl();
            timeslot.setFrom(begin);
            timeslot.setTo(end);
            timeslot.setLabel(temproom.getVeranstaltung());
            debug("current slot {} is {} ", timeslot.hashCode(), timeslot);

            timeSlots.add(timeslot);
/*
            isNotBooked = true;
            debug("Received {} slots", timeSlots.size());
            for (TimeSlotImpl slot : timeSlots) {
                if (!timeslotIsAvailable(slot, timeslot)) {
                    isNotBooked = false;
                    warn("does not contain = false");
                    break;
                }
            }
            if (isNotBooked) {
                timeSlots.add(timeslot);
                warn("isNotBooked = true");
            }

 */
        }
        //timeSlots.add(timeslot)
        return timeSlots;
    }


    private boolean timeslotIsAvailable(TimeSlotImpl dateOne, TimeSlotImpl dateTwo) {
        Boolean isAvailable = (dateOne.getLabel().equals(dateTwo.getLabel()) && dateOne.getTo().equals(dateTwo.getTo()) && dateOne.getFrom().equals(dateTwo.getFrom()));
        debug("Comparing {} to {} -> isSameSlot={}", dateOne, dateTwo, isAvailable);
        return !isAvailable;
    }
}
