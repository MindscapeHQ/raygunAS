/**
 * Created by zan on 05/02/2014.
 */
package com.mands.raygunas.raygunrequest
{
import flash.events.Event;
import flash.events.EventDispatcher;

import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
import nl.funkymonkey.android.deviceinfo.NativeDeviceInfoEvent;
import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;
import nl.funkymonkey.android.deviceinfo.NativeDevicePropertiesData;

//call this class before things blow up, preferably on app load and save it as variable, so you can use it easily.
public class DeviceData extends EventDispatcher
{
    public static const DEVICE_DATA_READY:String = "DeviceDataReady" ;

    public var _deviceName:String;
    public var _osVersion:String;

    public function get deviceName():String
    {
        return _deviceName;
    }
    public function get osVersion():String
    {
        return _osVersion;
    }

    public function loadDeviceData( os:String ):void
    {
        var deviceLineNumber:int = os.lastIndexOf("iPhone");
        if(deviceLineNumber < 0) deviceLineNumber = os.lastIndexOf("iPad");

        if(deviceLineNumber >= 0){

            _deviceName = os.substring(deviceLineNumber);
            _osVersion = os.substring(0, deviceLineNumber -1);

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

            else {
                _deviceName = "";
                _osVersion = "";
                dispatchEvent(new Event(DEVICE_DATA_READY));
            }

        }
    }

    private function handleDevicePropertiesParsed( event:NativeDeviceInfoEvent ):void
    {
        _deviceName = NativeDevicePropertiesData(NativeDeviceProperties.PRODUCT_MODEL ).value;
        _osVersion = NativeDevicePropertiesData(NativeDeviceProperties.OS_VERSION ).value;
        dispatchEvent(new Event(DEVICE_DATA_READY));
    }
}
}
