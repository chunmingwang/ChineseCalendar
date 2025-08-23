' DrawClockCalendar 绘制时钟日历
' Copyright (c) 2025 CM.Wang
' Freeware. Use at your own risk.

#include once "mff/Canvas.bi"
#include once "Lunar.bi"
	
#define vbRGB(r, g, b) CULng((CUByte(b) Shl 16) Or (CUByte(g) Shl 8) Or CUByte(r))

Type DitalClock
Private:
	mFontSize As Integer
	mDt As WString Ptr
	mColon As WString Ptr
	mW(2) As Integer
	mH(0) As Integer
	mOx As Integer
	mOy As Integer
	mCal As Lunar
	'index            0     1     2     3     4     5     6     7     8
	mC(8) As UByte = {&h00, &h1f, &h3f, &h5f, &h7f, &h9f, &hbf, &hdf, &hff}
	mShowSec As Boolean = True
	Declare Sub CalculateSize(Canvas As My.Sys.Drawing.Canvas, ByVal byHeight As Boolean = True)
Public:
	mClr(5) As ULong
	FontNameE As WString Ptr
	FontNameC As WString Ptr
	Mark As Long
	Declare Constructor
	Declare Destructor
	Declare Property ShowSecond() As Boolean
	Declare Property ShowSecond(b As Boolean)
	Declare Property Colon() ByRef As WString
	Declare Property Colon(s As WString)
	Declare Function FontSize() As Integer
	Declare Property Width() As Integer
	Declare Property Height() As Integer
	Declare Sub DrawClock(ByRef Canvas As My.Sys.Drawing.Canvas, DateTime As Double, ByVal byHeight As Boolean = True)
End Type

Type DayCalendar
Private:
	mFontSize As Integer
	mDt As WString Ptr
	mShowCalendar As Boolean
	mW(0) As Single
	mH(3) As Single
	mCal As Lunar
	'index            0     1     2     3     4     5     6     7     8
	mC(8) As UByte = {&h00, &h1f, &h3f, &h5f, &h7f, &h9f, &hbf, &hdf, &hff}
	mDrawStyle As Integer=0
	Declare Sub CalculateSize(Canvas As My.Sys.Drawing.Canvas, ByVal byHeight As Boolean = True)
Public:
	mClr(10) As ULong
	FontNameE As WString Ptr
	FontNameC As WString Ptr
	
	Declare Constructor
	Declare Destructor
	Declare Function FontSize() As Integer
	Declare Property DrawStyle() As Integer
	Declare Property DrawStyle(val As Integer)
	Declare Property Width() As Integer
	Declare Property Height() As Integer
	Declare Sub DrawDayCalendar(ByRef Canvas As My.Sys.Drawing.Canvas, DateTime As Double, ByVal byHeight As Boolean = True)
End Type

Type MonthCalendar
Private:
	'当天
	mDateTime As Double
	'当月第一天
	mDayStart As Double
	'当月天数
	mDayCount As Integer
	'当月第一天星期几 (星期日为每周第一天)
	mWeekStart As Integer
	'行数
	mLineCount As Integer
	'格子高
	mCellHeight As Single
	'格子宽
	mCellWidth As Single
	mCal As Lunar
	
	mColCount As Integer = 7
	
	'显示第几周
	mShowWeeks As Boolean = True
	'显示第几周的宽度
	mWeeksWidth As Single = 0
	
	mHeight As Integer
	mWidth As Integer
	mFontSize As Integer
	'index            0     1     2     3     4     5     6     7     8
	mC(8) As UByte = {&h00, &h1f, &h3f, &h5f, &h7f, &h9f, &hbf, &hdf, &hff}
Public:
	FontNameE As WString Ptr
	FontNameC As WString Ptr
	mClr(14) As ULong
	
	Declare Constructor
	Declare Destructor
	Declare Property ShowWeeks() As Boolean
	Declare Property ShowWeeks(val As Boolean)
	Declare Function XY2Date(x As Integer, y As Integer) As Double
	Declare Sub DrawMonthCalendar(ByRef Canvas As My.Sys.Drawing.Canvas, DateTime As Double, ByVal byHeight As Boolean = True)
End Type

#ifndef __USE_MAKE__
	#include once "DrawClockCalendar.bas"
#endif
