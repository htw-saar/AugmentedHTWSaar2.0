package de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Hibernate;

import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.AbstractDao;
import de.htwsaar.AugmentedHtwSaar.ARBackend.Model.Interface.User;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 */
@Entity
public class UserImpl extends AbstractDao implements User {
    @Column(unique = true)
    private String apiUser;
    private String apiSecret;
    private String firstName;
    private String lastName;
    private String EMail;
    private String Role;

    public UserImpl() {
    }

    public UserImpl(String apiUser, String apiSecret, String firstName, String lastName) {
        this.apiUser = apiUser;
        this.apiSecret = apiSecret;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getApiUser() {
        return apiUser;
    }

    public void setApiUser(String apiUser) {
        this.apiUser = apiUser;
    }

    public String getApiSecret() {
        return apiSecret;
    }

    public void setApiSecret(String apiSecret) {
        this.apiSecret = apiSecret;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEMail() {
        return EMail;
    }

    public void setEMail(String EMail) {
        this.EMail = EMail;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String role) {
        Role = role;
    }
}