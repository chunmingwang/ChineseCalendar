' Gregorian Calendar Lunar Calendar公历农历
' Copyright (c) 2025 CM.Wang
' Freeware. Use at your own risk.
' https://thuthuataccess.com/forum/thread-4765.html

#include once "Lunar.bi"

' 传入 y 传回干支, 0=甲子
Private Function Lunar.GanZhi(y As Integer) As UString
	Dim As Integer i = (y - 1864) Mod 60 '计算干支
	Function = *Gan(i Mod 10) & *Zhi(i Mod 12)
End Function

'计算年的属相字串
Private Function Lunar.YearAttribute(y As Integer)ByRef As WString
	Return *Animals((y - 1900) Mod 12)
End Function

'计算农历上的节气
Private Property Lunar.lSolarTerm()ByRef As WString
	Dim baseDateAndTime As Double
	Dim newdate As Double
	Dim num As Double
	
	baseDateAndTime = DateValue("1900/1/6") + TimeValue("2:05:00")
	
	Dim i As Integer
	For i = 1 To 24
		num = 525948.76 * (sYear - 1900) + TermInfo(i - 1)
		newdate = DateAdd("n", num, baseDateAndTime)  '按分钟计算,之所以不按秒钟计算，是因为会溢出
		If Abs(DateDiff("d", newdate, sDate)) = 0 Then
			Return *SolarTerm(i - 1)
		End If
	Next
	Return ""
End Property

'计算按第几周星期几计算的节日
Private Property Lunar.wHoliday()ByRef As WString
	Dim W As Integer
	Dim i As Integer
	Dim b As Integer
	Dim FirstDay As Double
	b = UBound(wHolidayDB)
	For i = 0 To b
		If wHolidayDB(i).Month = sMonth Then  '当月份相当时
			W = Weekday(sDate)
			If wHolidayDB(i).Recess = W Then  '仅当星期几也相等时
				FirstDay = DateValue(sMonth & "/" & 1 & "/" & sYear) '取当月第一天
				If (DateDiff("ww", FirstDay, sDate) = wHolidayDB(i).Day) Then
					Return *wHolidayDB(i).HolidayName
				End If
			End If
		End If
	Next
	Return ""
End Property

'求农历节日
Private Property Lunar.lHoliday()ByRef As WString
	Dim i As integer
	Dim b As integer
	Dim oy As integer
	Dim odate As Double
	Dim ndate As Double
	b = UBound(lHolidayDB)
	If lMonth = 12 And (lDay = 29 Or lDay = 30) Then
		oy = lYear '保存农历年数
		odate = sDate
		ndate = sDate + 1
		Init(Year(ndate), Month(ndate), Day(ndate)) '计算第二天的属性
		If oy = lYear - 1 Then '如果农历年数增加了1
			Init(Year(odate), Month(odate), Day(odate)) '恢复到今天原有数据
			Return "除夕"
		End If
	Else
		For i = 0 To b
			If (lHolidayDB(i).Month = lMonth) And _
				(lHolidayDB(i).Day = lDay) Then
				Return *lHolidayDB(i).HolidayName
			End If
		Next
	End If
	Return ""
End Property

'求公历节日
Private Property Lunar.sHoliday()ByRef As WString
	Dim i As integer
	Dim b As integer
	b = UBound(sHolidayDB)
	For i = 0 To b
		If (sHolidayDB(i).Month = sMonth) And _
			(sHolidayDB(i).Day = sDay) Then
			Return *sHolidayDB(i).HolidayName
		End If
	Next
	Return ""
End Property

'农历日期名
Private Function Lunar.lDayName(d As Integer) As UString
	Select Case d
	Case 0
	Case 10
		Function = "初十"
	Case 20
		Function = "二十"
	Case 30
		Function = "三十"
	Case Else
		Function = *nStr2(d \ 10) & *nStr1(d Mod 10)
	End Select
End Function

'初始化
Private Sub Lunar.Init(y As Integer, m As Integer, d As Integer)
	sYear = y
	sMonth = m
	sDay = d
	sDate = DateSerial(y, m, d)
	
	Dim DiffADate As Double, Counter As Integer, i As Integer, Temp As Integer
	DiffADate = DateDiff("d", DateValue("1900/1/31"), DateValue(y & "/" & m & "/" & d))

	Counter = -1
	lYear = 1900
	For i = lYear To 2199
		Temp = lYearDays(i)
		Counter = Counter + Temp
		If Counter >= DiffADate Then
			Counter = Counter - Temp
			Exit For
		End If
		lYear = lYear + 1
	Next
	
	Dim Leap As Integer
	Leap = LeapMonth(lYear)
	IsLeap = False
	lMonth = 1
	For i = 1 To 12
		If CBool(Leap > 0) And CBool(i = Leap + 1) And IsLeap = False Then
			IsLeap = True
			lMonth = lMonth - 1
			i = i - 1
			Temp = LeapDays(lYear)
		Else
			Temp = lMonthDays(lYear, i)
		End If
		If IsLeap = True And i <> Leap Then IsLeap = False
		Counter = Counter + Temp
		If Counter >= DiffADate Then
			Counter = Counter - Temp
			Exit For
		End If
		lMonth = lMonth + 1
	Next
	lDay = DiffADate - Counter
End Sub

'传回农历y年闰哪个月 1-12 , 没闰传回 0
Private Function Lunar.LeapMonth(y As Integer) As Integer
	If y >= 1900 Then
		Return LunarInfo(y - 1900) And &HF
	Else
		Return 0
	End If
End Function

'传回农历y年闰月的天数
Private Function Lunar.LeapDays(y As Integer) As Integer
	If LunarInfo(y - 1900) And &HF Then
		If LunarInfo(y - 1900) And &H10000 Then
			Return 30
		Else
			Return 29
		End If
	Else
		Return 0
	End If
End Function

'传回农历y年m月的总天数
Private Function Lunar.lMonthDays(y As Integer, m As Integer) As Integer
	If LunarInfo(y - 1900) And MonthMask(m - 1) Then
		Return 30
	Else
		Return 29
	End If
End Function

'传回农历y年的总天数
Private Function Lunar.lYearDays(y As Integer) As Integer
	Dim i As Integer
	Dim mYearDays As Integer = 348
	For i = 0 To 11
		If LunarInfo(y - 1900) And MonthMask(i) Then mYearDays = mYearDays + 1
	Next
	mYearDays = mYearDays + LeapDays(y)
	Return mYearDays
End Function


