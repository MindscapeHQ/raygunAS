/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{
import com.mands.raygunas.raygunrequest.StackLine;

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


}
}
