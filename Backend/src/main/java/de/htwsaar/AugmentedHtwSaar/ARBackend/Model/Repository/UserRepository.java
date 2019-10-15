package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Repository;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate.UserImpl;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Spring-Data repository for easy model access
 */
@Repository
public interface UserRepository extends JpaRepository<UserImpl, Long> {
    User findUserByapiUser(String apiUser);
}