/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{
import flash.events.Event;
import flash.events.UncaughtErrorEvent;
import flash.system.Capabilities;

import mockolate.nice;

import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNull;

import org.flexunit.async.Async;
import org.hamcrest.object.nullValue;

public class RaygunTestCase
{
    private var raygunAs:RaygunAs;

    [Before(async, timeout=5000)]
    public function prepareMockolates():void
    {
        Async.proceedOnEvent(this,
                prepare(UncaughtErrorEvent, Error),
                Event.COMPLETE);

        raygunAs = new RaygunAs();
    }

    [Test]
    public function test_empty_mock_error_should_have_no_message():void
    {
        var error:Error = nice(Error);
        assertThat(error.message, nullValue());
    }

    [Test]
    public function test_getFileLineNumber_should_return_line_number_from_stacktrace():void
    {
        var error:Error = nice(Error);
        stub(error).method("getStackTrace" ).returns("ArgumentError: Error #2015: Invalid BitmapData." +
        "\nat flash.display::BitmapData/ctor()"+
        "\nat flash.display::BitmapData()" +
        "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/generateBitmapData()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:159]" +
        "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/copyBitmaps()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:240]" +
        "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]" +
        "\nat com.xtdstudios.common.threads::RunnablesList/process()[C:\Users\gil\Adobe Flash Builder 4.7\XTDCommon\src\com\xtdstudios\common\threads\RunnablesList.as:63]" +
        "\nat com.xtdstudios.common.threads::BasePseudoThread/onTimer()[C:\Users\gil\Adobe Flash Builder 4.7\XTDCommon\src\com\xtdstudios\common\threads\BasePseudoThread.as:54]" +
        "\nat flash.utils::Timer/_timerDispatch()" +
        "\nat flash.utils::Timer/tick()");


        var exceptionLine:String = "at com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]";
        var number:String = raygunAs.getFileLineNumber(exceptionLine);
        assertEquals("274", number);

        exceptionLine = "at com.xtdstudios.common.threads::BasePseudoThread/onTimer()[C:\Users\gil\Adobe Flash Builder 4.7\XTDCommon\src\com\xtdstudios\common\threads\BasePseudoThread.as:54]";
        number = raygunAs.getFileLineNumber(exceptionLine);
        assertEquals("54", number);

    }

    [Test]
    public function test_getFileLineNumber_should_return_null_when_there_is_no_line_number():void
    {

        var exceptionLine:String = "at flash.utils::Timer/_timerDispatch()";
        var number:String = raygunAs.getFileLineNumber(exceptionLine);
        assertNull(number);
    }

    [Test]
    public function test_getClassName_should_return_a_class_name_from_stacktrace():void
    {
        var exceptionLine:String = "at com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]";
        var className:String = raygunAs.getClassName(exceptionLine);
        assertEquals("com.xtdstudios.DMT.atlas::AtlasGenerator", className);

        exceptionLine = "at flash.display::BitmapData()";
        className = raygunAs.getClassName(exceptionLine);
        assertEquals("flash.display::BitmapData", className);
    }

    [Test]
    public function test_getFileName_should_return_a_file_name_from_stacktrace():void
    {
        var exceptionLine:String = "at com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]";
        var fileName:String = raygunAs.getFileName(exceptionLine);
        assertEquals("C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as", fileName);
    }

    [Test]
    public function test_getFileName_should_return_an_empty_string_if_there_is_no_file_name_in_stacktrace():void
    {
        var exceptionLine:String = "at flash.display::BitmapData()";
        var fileName:String = raygunAs.getFileName(exceptionLine);
        assertEquals("", fileName);
    }

    [Test]
    public function test_getMethodName_should_return_a_method_name_from_stacktrace():void
    {
        var exceptionLine:String = "at com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]";
        var methodName:String = raygunAs.getMethodName(exceptionLine);
        assertEquals("process()", methodName);
    }

    [Test]
    public function test_getMethodName_should_return_constructor_name_from_stacktrace_when_method_is_a_constructor():void
    {
        var exceptionLine:String = "at flash.display::BitmapData()";
        var methodName:String = raygunAs.getMethodName(exceptionLine);
        assertEquals("BitmapData()", methodName);
    }

    [Test(async, timeout=1000)]
    public function test_getDeviceModel_should_return_iPhone_for_iOS_device():void
    {
        var os:String = "iPhone OS 7.1 iPhone4,1";
        var check:Function = function(e:Event,... args):void
        {
            assertEquals("iPhone4,1", DeviceData.deviceModel);
            trace("DEVICE MODEL", DeviceData.deviceModel);
        }
        Async.handleEvent(this, raygunAs, RaygunAs.DEVICE_DATA_READY, check, 1000);
        raygunAs.getDeviceModel(os);
    }

    [Test(async, timeout=1000)]
    public function test_getOSVersion_should_return_iPhone_OS_for_iOS_device():void
    {
        var os:String = "iPhone OS 7.1 iPhone4,1";
        var check:Function = function(e:Event,... args):void
        {
            assertEquals("iPhone OS 7.1", DeviceData.osVersion);
            trace("OS Version", DeviceData.osVersion);
        }
        Async.handleEvent(this, raygunAs, RaygunAs.DEVICE_DATA_READY, check, 1000);
        raygunAs.getOSVersion(os);
    }


}
}
