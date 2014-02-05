/**
 * Created by zan on 04/02/2014.
 */
package com.mands.raygunas.raygunrequest
{
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import nl.funkymonkey.android.deviceinfo.NativeDeviceInfo;
import nl.funkymonkey.android.deviceinfo.NativeDeviceInfoEvent;
import nl.funkymonkey.android.deviceinfo.NativeDeviceProperties;
import nl.funkymonkey.android.deviceinfo.NativeDevicePropertiesData;

public class Environment  implements IEventDispatcher
{
    public var osVersion:String;
    public var deviceName:String;
    public var currentOrientation:String;
    public var windowBoundsWidth:Number;
    public var windowBoundsHeight:Number;

    public static const DEVICE_DATA_READY:String = "DeviceDataReady" ;

    private var dispatcher:EventDispatcher;


    public function Environment(mainStage:Stage = null)
    {
        dispatcher = new EventDispatcher();

        if(mainStage != null){
            windowBoundsHeight = mainStage.height;
            windowBoundsWidth = mainStage.width;
            currentOrientation = mainStage.orientation;
        }
    }

    public function loadDeviceData(os:String, callback:Function = null):void{

        var deviceLineNumber:int = os.lastIndexOf("iPhone");
        if(deviceLineNumber < 0) deviceLineNumber = os.lastIndexOf("iPad");

        if(deviceLineNumber >= 0){

            deviceName = os.substring(deviceLineNumber);
            osVersion = os.substring(0, deviceLineNumber -1);

            dispatchEvent(new Event(DEVICE_DATA_READY ));
            if(callback != null)
            {
                callback.call();
            }
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
        deviceName = NativeDevicePropertiesData(NativeDeviceProperties.PRODUCT_MODEL ).value;
        osVersion = NativeDevicePropertiesData(NativeDeviceProperties.OS_VERSION ).value;
        dispatchEvent(new Event(DEVICE_DATA_READY));
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




}
}
