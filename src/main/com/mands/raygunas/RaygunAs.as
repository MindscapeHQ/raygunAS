/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.system.Capabilities;

import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
import nl.funkymonkey.android.deviceinfo.NativeDeviceInfoEvent;
import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;
import nl.funkymonkey.android.deviceinfo.NativeDevicePropertiesData;

public class RaygunAs implements IEventDispatcher
{
    public static const DEVICE_DATA_READY:String = "DeviceDataReady" ;

    private var dispatcher:EventDispatcher;

    public function RaygunAs()
    {
        dispatcher = new EventDispatcher();
    }

    public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
    {
        dispatcher.addEventListener(type, listener, useCapture, priority);
    }


    public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
    {
        dispatcher.removeEventListener(type, listener, useCapture);
    }

    public function dispatchEvent( event:Event ):Boolean
    {
        return dispatcher.dispatchEvent(event);
    }

    public function hasEventListener( type:String ):Boolean
    {
        return dispatcher.hasEventListener(type);
    }

    public function willTrigger( type:String ):Boolean
    {
        return dispatcher.willTrigger(type);
    }

    public function getFileLineNumber(exceptionLine:String):String
    {
        var numberIndex = exceptionLine.indexOf(".as:");
        if(numberIndex <= 0){
            return null;
        }
        else  return exceptionLine.slice(numberIndex+4, exceptionLine.length-1);
        }

    public function getDeviceModel(os:String)
    {
        var deviceLineNumber:int = os.lastIndexOf("iPhone");
        if(deviceLineNumber < 0) deviceLineNumber = os.lastIndexOf("iPad");

        if(deviceLineNumber >= 0){

            DeviceData.deviceModel = os.substring(deviceLineNumber);
            dispatchEvent(new Event(DEVICE_DATA_READY ));
        }
        else{
            //check for Android
            deviceLineNumber = os.indexOf("Linux");
            if(deviceLineNumber >= 0)
            {
                var deviceInfo : NativeDeviceInfo = new NativeDeviceInfo();
                deviceInfo.addEventListener(NativeDeviceInfoEvent.PROPERTIES_PARSED, handleDevicePropertiesParsed);
                deviceInfo.setDebug(false);
                deviceInfo.parse();
            }
        }
    }

    public function getOSVersion( os:String ):void
    {
        var deviceLineNumber:int = os.lastIndexOf("iPhone");
        if(deviceLineNumber < 0) deviceLineNumber = os.lastIndexOf("iPad");

        if(deviceLineNumber >= 0){

            DeviceData.osVersion = os.substring(0, deviceLineNumber -1);
            dispatchEvent(new Event(DEVICE_DATA_READY ));
        }
        else{
            //check for Android
            deviceLineNumber = os.indexOf("Linux");
            if(deviceLineNumber >= 0)
            {
                var deviceInfo : NativeDeviceInfo = new NativeDeviceInfo();
                deviceInfo.addEventListener(NativeDeviceInfoEvent.PROPERTIES_PARSED, handleDevicePropertiesParsed);
                deviceInfo.setDebug(false);
                deviceInfo.parse();
            }
        }
    }

    private function handleDevicePropertiesParsed( event:NativeDeviceInfoEvent ):void
    {
        DeviceData.deviceModel = NativeDevicePropertiesData(NativeDeviceProperties.PRODUCT_MODEL ).value;
        DeviceData.osVersion = NativeDevicePropertiesData(NativeDeviceProperties.OS_VERSION ).value;
    }

    public function getClassName( exceptionLine:String ):String
    {
      var classNameBeginIndex:int = 3;
      var classNameEndIndex:int = exceptionLine.indexOf("/");
      if(classNameEndIndex < 0)
          classNameEndIndex = exceptionLine.indexOf("()");

      return exceptionLine.slice(classNameBeginIndex, classNameEndIndex);

    }

    public function getFileName( exceptionLine:String ):String
    {
        var fileNameBeginIndex:int = exceptionLine.indexOf("[");
        var fileNameEndIndex:int = exceptionLine.lastIndexOf(":");
        if(fileNameBeginIndex >= 0){
            return exceptionLine.slice(fileNameBeginIndex + 1, fileNameEndIndex);
        }
        else{
            return "";
        }
    }

    public function getMethodName( exceptionLine:String ):String
    {
        var className = getClassName(exceptionLine);
        var methodNameBeginIndex:int = exceptionLine.indexOf(className ) + className.length;
        if(exceptionLine.charAt(methodNameBeginIndex) == "/"){
            methodNameBeginIndex++;
        }
        else if(exceptionLine.charAt(methodNameBeginIndex) == "("){
            methodNameBeginIndex = exceptionLine.indexOf("::")+2;
        }
        var methodNameEndIndex:int = exceptionLine.indexOf("()");
        return exceptionLine.slice(methodNameBeginIndex, methodNameEndIndex+2);
    }

}
}
