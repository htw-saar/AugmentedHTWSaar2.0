package de.htwsaar.AugmentedHtwSaar.ARBackend.Logging;
/**
 * @author Peter Klein, Robin Bachmann, Matthias Tritt
 * <p>
 * Static Logger Class (wrapepr for log4j/slf4j)
 */

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.regex.Pattern;

public class StaticLogger {
    public static void error(Class loggedClass, String logMessage, Exception e) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.error(logMessage, e);
    }

    public static void error(Class loggedClass, Exception e) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.error(e.getMessage(), e);
    }

    public static void errorWithStackTrace(Class loggedClass, String logMessage, Object... interpolateArguments) {
        StringWriter stringWriter = new StringWriter();
        new Throwable(interpolate(loggedClass, logMessage, interpolateArguments)).printStackTrace(new PrintWriter(stringWriter));
        String stackTrace = stringWriter.toString();
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.error(logMessage, interpolateArguments);
        LoggerInstance.error("{}", stackTrace);
    }

    public static void error(Class loggedClass, String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.error(logMessage, interpolateArguments);
    }

    public static void warnWithStackTrace(Class loggedClass, String logMessage, Object... interpolateArguments) {
        StringWriter stringWriter = new StringWriter();
        new Throwable(interpolate(loggedClass, logMessage, interpolateArguments)).printStackTrace(new PrintWriter(stringWriter));
        String stackTrace = stringWriter.toString();
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.warn(logMessage, interpolateArguments);
        LoggerInstance.warn("{}", stackTrace);
    }

    public static void warn(Class loggedClass, String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.warn(logMessage, interpolateArguments);
    }

    public static void info(Class loggedClass, String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.info(logMessage, interpolateArguments);
    }

    public static void debug(Class loggedClass, String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.debug(logMessage, interpolateArguments);
    }

    public static void trace(Class loggedClass, String logMessage, Object... interpolateArguments) {
        Logger LoggerInstance = LoggerFactory.getLogger(loggedClass);
        LoggerInstance.trace(logMessage, interpolateArguments);
    }

    public static void sql(Class loggedClass, String logMessage, Object... interpolateArguments) {
        debug(loggedClass, "[SQL] " + logMessage, interpolateArguments);
    }

    public static String interpolate(Class loggedClass, String logMessage, Object... interpolationArguments) {
        for (Object argument : interpolationArguments) {
            logMessage = logMessage.replaceFirst(Pattern.quote("{}"), argument.toString());
        }
        return logMessage;
    }
}
