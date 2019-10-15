package de.htwsaar.AugmentedHtwSaar.ARBackend.Service;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Authenticators.HMACAuthenticationFilter;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Logging.Loggable;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.UserImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Service controller for the user path
 */
@RestController
@RequestMapping("/api/v1/user")
public class UserService implements Loggable {

    @Autowired
    UserRepository userRepository;

    @RequestMapping(value = "", method = RequestMethod.POST, consumes = "application/json", produces = "application/json")
    public ResponseEntity<UserImpl> createUser(@RequestBody UserImpl user) {
        try {
            userRepository.save(user);
            return ResponseEntity.ok().body(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @RequestMapping(value = "", method = RequestMethod.GET, consumes = "application/json", produces = "application/json")
    public ResponseEntity<UserImpl> getUser() {
        try {
            UserImpl authenticatedUser = HMACAuthenticationFilter.getUser();
            if (authenticatedUser == null)
                return ResponseEntity.noContent().build();
            return ResponseEntity.ok().body(authenticatedUser);
        } catch (Exception e) {
            error("{}", e);
            return ResponseEntity.noContent().build();
        }
    }
}
