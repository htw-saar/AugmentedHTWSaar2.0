package de.htwsaar.AugmentedHtwSaar.ARBackend.Service;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators.HMACAuthenticationFilter;
import de.htwsaar.AugmentedHtwSaar.ARBackend.ExternalApis.HTWRoomService.RoomServiceApi;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.FavoriteImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.HistoryImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.RoomImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.UserImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.FavoriteRepository;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.HistoryRepository;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.UserRepository;
import feign.Param;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Service controller for the room path
 */
@RestController
@RequestMapping("/api/v1/room")
@ApiOperation(value = "Anfragen die Räume betreffen")
public class RoomService implements Loggable {
    private static final String ROOMIDDOC = "Raumnummer";
    private static final String BEGDATEDOC = "Startdatum YYYY-MM-dd";
    private static final String ENDDATEDOC = "Enddatum YYYY.MM.dd";
    private static final String DATEDOC = "Datum YYYY-MM-dd";
    private static final String FROMTIMEDOC = "Startzeitpunkt HH:mm";
    private static final String TOTIMEDOC = "Endzeitpunkt HH:mm";
    private static final String APIKEYDOC = "API-Key für den Raumservice der HTW";
    private static final String EVENTDOC = "Beschreibung der zu buchenden Veranstalltung";
    private static final String USERWITHPERMISIONDOC = "Freigeschalteter Benutzername für die API der HTW";
    private static final String USERDOC = "Benutzername des aktuellen Nutzers";
    @Autowired
    RoomServiceApi roomService;
    @Autowired
    FavoriteRepository favoriteRepository;
    @Autowired
    HistoryRepository historyRepository;
    @Autowired
    UserRepository userRepository;

    @ApiOperation(value = "Fragt sämtliche Informationen über einen Raum ab. Und fügt diesen zum Verlauf hinzu.")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Erfolg"),
            @ApiResponse(code = 204, message = "Keine Daten von Raumservice Api erhalten")})
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<RoomImpl> getRoom(@ApiParam(value = ROOMIDDOC, required = true)
                                            @PathVariable("id")
                                                    String id,
                                            @ApiParam(value = BEGDATEDOC, required = true)
                                            @Param("date_beg")
                                                    String date_beg,
                                            @ApiParam(value = ENDDATEDOC, required = true)
                                            @Param("date_end")
                                                    String date_end
    ) {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            HistoryImpl history = (HistoryImpl) historyRepository.findByUser(authenticatedUser);
            if (history == null) {
                history = new HistoryImpl();
                history.setUser(authenticatedUser);
                history.setHistory(new HashMap<Instant, String>());
            }
            history.addHistory(id);
            historyRepository.save(history);
            return ResponseEntity.ok().body(roomService.getRoom(id, date_beg, date_end));
        } catch (Exception e) {
            error("getUser", e);
            return ResponseEntity.noContent().build();
        }
    }

    @ApiOperation(value = "Bucht einen Raum")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Anfrage wurde bearbeitet. Das Ergebnis der Anfrage steht in dem Responsebody im Feld sucess (boolean). Weitere Informationen stehen im Status.")

    })
    @RequestMapping(value = "/book/{id}", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Object> bookRoom(@PathVariable("id") @ApiParam(value = ROOMIDDOC, required = true) String id,
                                           @Param("key") @ApiParam(value = APIKEYDOC, required = true) String key,
                                           @Param("date") @ApiParam(value = DATEDOC, required = true) String date,
                                           @Param("from") @ApiParam(value = FROMTIMEDOC, required = true) String from,
                                           @Param("to") @ApiParam(value = TOTIMEDOC, required = true) String to,
                                           @Param("event") @ApiParam(value = EVENTDOC, required = true) String event,
                                           @Param("user") @ApiParam(value = USERWITHPERMISIONDOC, required = true) String user) {
        try {
            return ResponseEntity.ok().body(roomService.bookRoom(key, id, date, from, to, event, user));
        } catch (Exception e) {
            error("bookRoom()", e);
            return ResponseEntity.noContent().build();
        }
    }

    @ApiOperation(value = "Storniert eine Reservierung für einen Raum")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Anfrage wurde bearbeitet. Das Ergebnis der Anfrage steht in dem Responsebody im Feld sucess (boolean). Weitere Informationen stehen im Status.")})
    @RequestMapping(value = "/cancel/{id}", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Object> cancelReservation(@PathVariable("id") @ApiParam(value = ROOMIDDOC, required = true) String id,
                                                    @Param("key") @ApiParam(value = APIKEYDOC, required = true) String key,
                                                    @Param("date") @ApiParam(value = DATEDOC, required = true) String date,
                                                    @Param("from") @ApiParam(value = FROMTIMEDOC, required = true) String from,
                                                    @Param("to") @ApiParam(value = TOTIMEDOC, required = true) String to,
                                                    @Param("user") @ApiParam(value = USERWITHPERMISIONDOC, required = true) String user) {
        try {
            return ResponseEntity.ok().body(roomService.cancelReservation(key, id, date, from, to, user));
        } catch (Exception e) {
            error("cancelReservation", e);
            return ResponseEntity.noContent().build();
        }
    }


    @ApiOperation(value = "Fügt einen Raum zu den persönlichen Favoriten hinzu.")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Erfolg"),
            @ApiResponse(code = 204, message = "Nicht hinzugefügt")})
    @RequestMapping(value = "/favorite/{id}", method = RequestMethod.PUT, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Set<String>> addFavoriteRoom(@PathVariable("id") @ApiParam(value = ROOMIDDOC, required = true) String id) {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            FavoriteImpl favorite = (FavoriteImpl) favoriteRepository.findByUser(authenticatedUser);
            if (favorite == null) {
                favorite = new FavoriteImpl();
                favorite.setUser(authenticatedUser);
                favorite.setFavorites(new HashSet<>());
            }
            favorite.addFavorite(id);
            favoriteRepository.save(favorite);
            return ResponseEntity.ok().body(favorite.getFavorites());
        } catch (Exception e) {
            error("{}", e);
            return ResponseEntity.noContent().build();
        }
    }

    @ApiOperation(value = "Entfernt einen Raum aus persönlichen Favoriten.")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Erfolg", examples = @io.swagger.annotations.Example(
                    value = {
                            @ExampleProperty(value = "[\"5206\", \"...\"]", mediaType = "application/json")
                    })),
            @ApiResponse(code = 204, message = "Fehler beim Löschen des Favoriten")})
    @RequestMapping(value = "/favorite/{id}", method = RequestMethod.DELETE, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Set<String>> deleteFavoriteRoom(
            @PathVariable("id") @ApiParam(value = ROOMIDDOC, required = true) String id) {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            FavoriteImpl favorite = (FavoriteImpl) favoriteRepository.findByUser(authenticatedUser);
            if (favorite == null) {
                favorite = new FavoriteImpl();
                favorite.setUser(authenticatedUser);
                favorite.setFavorites(new HashSet<>());
            }
            favorite.removeFavorite(id);
            favoriteRepository.save(favorite);
            return ResponseEntity.ok().body(favorite.getFavorites());
        } catch (Exception e) {
            error("{}", e);
            return ResponseEntity.noContent().build();
        }
    }

    @ApiOperation(value = "Frägt sämtliche zu den Favoriten hinzugefügten Räumen des aktuellen Users ab")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Erfolg"),
            @ApiResponse(code = 204, message = "Nicht erfolgreich")})
    @RequestMapping(value = "/favorite", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Set<String>> getFavoriteRooms() {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            FavoriteImpl favorite = (FavoriteImpl) favoriteRepository.findByUser(authenticatedUser);
            if (favorite == null)
                return ResponseEntity.ok().body(new HashSet<>());
            return ResponseEntity.ok().body(favorite.getFavorites());
        } catch (Exception e) {
            error("{}", e);
            return ResponseEntity.noContent().build();
        }
    }

    @ApiOperation(value = "Frägt den Verlauf der zuvor abgefragen Räume eines users ab.")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Erfolg"),
            @ApiResponse(code = 204, message = "Nicht erfolgreich")})
    @RequestMapping(value = "/history", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<Object> getUserHistory() {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            HistoryImpl history = (HistoryImpl) historyRepository.findByUser(authenticatedUser);
            if (history == null)
                return ResponseEntity.ok().body(new HashMap<>());
            return ResponseEntity.ok().body(history.getHistory());
        } catch (Exception e) {
            error("{}", e);
            return ResponseEntity.noContent().build();
        }
    }
}
