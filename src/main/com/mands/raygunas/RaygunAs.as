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






}
}
