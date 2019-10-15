package de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService;

import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model.RequestBody;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.Model.Room;
import feign.QueryMap;
import feign.RequestLine;

import java.util.List;
import java.util.Map;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Defines all available api-calls and their map
 */
public interface RoomServiceApiInterface {
    @RequestLine("GET /api/raumapi.php")
    RequestBody<List<Room>> getRoom(@QueryMap Map<String, Object> queryMap);

    @RequestLine("GET /api/raum_resapi.php")
    RequestBody<Object> bookRoom(@QueryMap Map<String, Object> queryMap);

    @RequestLine("GET /api/raum_delapi.php")
    RequestBody<Object> cancelReservation(@QueryMap Map<String, Object> queryMap);

}