/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{

import com.mands.raygunas.raygunrequest.DeviceData;
import com.mands.raygunas.raygunrequest.Environment;
import com.mands.raygunas.raygunrequest.ErrorDetails;
import com.mands.raygunas.raygunrequest.StackLine;

import flash.events.Event;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.async.Async;

public class RaygunTestCase
{
    private var _raygunAs:RaygunAS;

    private var _fullStackTrace:String = "ArgumentError: Error #2015: Invalid BitmapData." +
            "\nat flash.display::BitmapData/ctor()"+
            "\nat flash.display::BitmapData()" +
            "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/generateBitmapData()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:159]" +
            "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/copyBitmaps()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:240]" +
            "\nat com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]" +
            "\nat com.xtdstudios.common.threads::RunnablesList/process()[C:\Users\gil\Adobe Flash Builder 4.7\XTDCommon\src\com\xtdstudios\common\threads\RunnablesList.as:63]" +
            "\nat com.xtdstudios.common.threads::BasePseudoThread/onTimer()[C:\Users\gil\Adobe Flash Builder 4.7\XTDCommon\src\com\xtdstudios\common\threads\BasePseudoThread.as:54]" +
            "\nat flash.utils::Timer/_timerDispatch()" +
            "\nat flash.utils::Timer/tick()";
    private var _stackTraceLineWithFileName:String = "at com.xtdstudios.DMT.atlas::AtlasGenerator/process()[C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as:274]";
    private var _stackTraceLineWithoutFileName:String = "at flash.display::BitmapData/ctor()";
    private var _stackTraceLineWithConstructorMethod:String = "at flash.display::BitmapData()";
    private var _osWithIOS:String = "iPhone OS 7.1 iPhone4,1";



    [Before(async, timeout=5000)]
    public function init():void
    {
        _raygunAs = new RaygunAS();
    }

    [Test]
    public function test_getFileLineNumber_should_return_line_number_from_stacktrace():void
    {
        var number:int = StackLine.getFileLineNumber(_stackTraceLineWithFileName);
        assertEquals(274, number);
    }

    [Test]
    public function test_getFileLineNumber_should_return_minus_1_when_there_is_no_line_number():void
    {
        var number:int = StackLine.getFileLineNumber(_stackTraceLineWithoutFileName);
        assertEquals(-1, number);
    }

    [Test]
    public function test_getClassName_should_return_a_class_name_from_stacktrace():void
    {
        var className:String = StackLine.getClassName(_stackTraceLineWithFileName);
        assertEquals("com.xtdstudios.DMT.atlas::AtlasGenerator", className);

        className = StackLine.getClassName(_stackTraceLineWithConstructorMethod);
        assertEquals("flash.display::BitmapData", className);
    }

    [Test]
    public function test_getFileName_should_return_a_file_name_from_stacktrace():void
    {
        var fileName:String = StackLine.getFileName(_stackTraceLineWithFileName);
        assertEquals("C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as", fileName);
    }

    [Test]
    public function test_getFileName_should_return_an_empty_string_if_there_is_no_file_name_in_stacktrace():void
    {
        var fileName:String = StackLine.getFileName(_stackTraceLineWithoutFileName);
        assertEquals("", fileName);
    }

    [Test]
    public function test_getMethodName_should_return_a_method_name_from_stacktrace():void
    {
        var methodName:String = StackLine.getMethodName(_stackTraceLineWithFileName);
        assertEquals("process()", methodName);
    }

    [Test]
    public function test_getMethodName_should_return_constructor_name_from_stacktrace_when_method_is_a_constructor():void
    {
        var methodName:String = StackLine.getMethodName(_stackTraceLineWithConstructorMethod);
        assertEquals("BitmapData()", methodName);
    }


    [Test(async, timeout=1000)]
    public function test_getDeviceData_should_load_iPhone_and_iOS_version_for_iOS_device():void
    {

        var deviceData:DeviceData = new DeviceData();
        var check:Function = function(e:Event,... args):void
        {
            assertEquals("iPhone4,1", deviceData.deviceName);
            assertEquals("iPhone OS 7.1", deviceData.osVersion);
        }
        Async.handleEvent(this, deviceData, DeviceData.DEVICE_DATA_READY, check, 1000);

        deviceData.loadDeviceData(_osWithIOS);
    }


    [Test]
    public function test_parseStackTrace_should_return_array_of_StackLine_objects():void
    {
        var stackTraceArray:Array = ErrorDetails.parseStackTrace(_fullStackTrace);
        assertEquals(9,stackTraceArray.length);
    }

    [Test]
    public function test_parseStackLine_should_return_a_StackLine_object_with_no_filename_and_lineNumber_when_stackTrace_line_doesnt_have_it():void
    {
        var stackLine = new StackLine(_stackTraceLineWithConstructorMethod);

        assertEquals("flash.display::BitmapData", stackLine.className);
        assertEquals("BitmapData()", stackLine.methodName);
        assertEquals(-1, stackLine.lineNumber);
        assertEquals("", stackLine.fileName);
    }

    [Test]
    public function test_parseStackLine_should_return_a_StackLine_object():void
    {
        var stackLine = new StackLine(_stackTraceLineWithFileName);
        assertEquals("com.xtdstudios.DMT.atlas::AtlasGenerator", stackLine.className);
        assertEquals("process()", stackLine.methodName);
        assertEquals(274, stackLine.lineNumber);
        assertEquals("C:\Users\gil\Adobe Flash Builder 4.7\DMT\DMT\src\com\xtdstudios\DMT\atlas\AtlasGenerator.as", stackLine.fileName);
    }

    [Test]
    public function test_constructErrorDetails_from_errorEvent_should_create_error_instance():void
    {
        var error:Error = new TypeError("Error #1009: Cannot access a property or method of a null object reference.");
        var errorDetails:ErrorDetails = new ErrorDetails(error);
        assertEquals("Error #1009: Cannot access a property or method of a null object reference.", errorDetails.message);
        assertEquals("TypeError", errorDetails.className);
        assertNotNull(errorDetails.stackTrace);
    }

    [Test]
    public function test_parseErrorClass_should_create_error_class_name_from_stack_trace():void
    {
        var errorClass:String = ErrorDetails.parseErrorClass(_fullStackTrace);
        assertEquals("ArgumentError", errorClass);
    }

    [Test(async, timeout=10000)]
    public function testPerformRequest()
    {
        var error:Error = new TypeError("Error #1009: Cannot access a property or method of a null object reference.");

        Async.proceedOnEvent(this, _raygunAs, RaygunAS.RAYGUN_COMPLETE, 10000);
        _raygunAs.performRequest("0.01", error, null);
    }



}
}
