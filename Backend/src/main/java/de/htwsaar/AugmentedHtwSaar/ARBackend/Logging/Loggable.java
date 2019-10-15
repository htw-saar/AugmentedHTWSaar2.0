package de.htwsaar.AugmentedHtwSaar.ARBackend.Logging;

/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Logging (wrapper-) interface for the static logger class
 */

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.regex.Pattern;

public interface Loggable {

    /**
     * Loggs a message with "error" severity
     *
     * @param logMessage the message
     * @param e          the exception
     */
    default void error(String logMessage, Exception e) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.error(logMessage, e);
    }

    /**
     * Loggs an exception with "error" severity
     *
     * @param e the exception
     */
    default void error(Exception e) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.error(e.getMessage(), e);
    }

    /**
     * Loggs a message with "error" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the exception
     */
    default void errorWithStackTrace(String logMessage, Object... interpolateArguments) {
        StringWriter stringWriter = new StringWriter();
        new Throwable(interpolate(logMessage, interpolateArguments)).printStackTrace(new PrintWriter(stringWriter));
        String stackTrace = stringWriter.toString();
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.error(logMessage, interpolateArguments);
        LoggerInstance.error("{}", stackTrace);
    }

    /**
     * Loggs a message with "error" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void error(String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.error(logMessage, interpolateArguments);
    }

    /**
     * Loggs a message with "warn" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the exception
     */
    default void warnWithStackTrace(String logMessage, Object... interpolateArguments) {
        StringWriter stringWriter = new StringWriter();
        new Throwable(interpolate(logMessage, interpolateArguments)).printStackTrace(new PrintWriter(stringWriter));
        String stackTrace = stringWriter.toString();
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.warn(logMessage, interpolateArguments);
        LoggerInstance.warn("{}", stackTrace);
    }

    /**
     * Loggs a message with "warn" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void warn(String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.warn(logMessage, interpolateArguments);
    }

    /**
     * Loggs a message with "info" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void info(String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.info(logMessage, interpolateArguments);
    }

    /**
     * Loggs a message with "debug" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void debug(String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.debug(logMessage, interpolateArguments);
    }

    /**
     * Loggs a message with "trace" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void trace(String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(this.getClass());
        LoggerInstance.trace(logMessage, interpolateArguments);
    }

    /**
     * Loggs a message with "sql" severity and writes a stacktrace
     *
     * @param logMessage           the message
     * @param interpolateArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default void sql(String logMessage, Object... interpolateArguments) {
        debug("[SQL] " + logMessage, interpolateArguments);
    }

    /**
     * Interpolates a logMessage (replace {} token with theor toStrign representation
     *
     * @param logMessage             the message
     * @param interpolationArguments the arguments which interpolate the {} placeholders in logMessage
     */
    default String interpolate(String logMessage, Object... interpolationArguments) {
        for (Object argument : interpolationArguments) {
            logMessage = logMessage.replaceFirst(Pattern.quote("{}"), argument.toString());
        }
        return logMessage;
    }
}
