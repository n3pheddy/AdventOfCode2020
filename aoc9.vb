Imports System.IO

''' <summary>
''' Contains 2 functions. (1) Given a list of number and length of values (window) to look back,
''' find a number where there are no sum of 2 numbers in the window. (2) Given a number, find a
''' contiguous sequence of numbers before it, then sum the smallest and largest number.
''' </summary>
Module aoc9
    ' Range of values for comparison.
    Public Const Window = 25

    ''' <summary>
    ''' Given a targetValue, look for a contiguous sequence of numbers before it that adds up
    ''' to it, then return the sum of the smallest and largest numbers.
    ''' 
    ''' *Time complexity: O(n)
    ''' Space complexity: O(1)
    ''' Where n = lines.Length
    ''' 
    ''' * Depends on the implementation of Queue.Min and Queue.Max. Assumed to be O(1).
    ''' </summary>
    Function FindSumMatching(lines As String(), targetValue As Long) As Long
        Dim recentValues = New Queue(Of Long)
        Dim acc As Long = 0

        For Each line In lines
            Dim value = Long.Parse(line)
            recentValues.Enqueue(value)
            acc += value

            While acc > targetValue
                acc -= recentValues.Dequeue()
            End While

            If acc = targetValue Then
                Return recentValues.Min + recentValues.Max
            End If
        Next

        Throw New InvalidDataException("No solution!")
    End Function

    ''' <summary>
    ''' Find a value that does not satisfy the condition. The condition being, given a length indicating
    ''' the number of values before it, there exists 2 numbers when summed gives the value.
    ''' 
    ''' Time complexity : O(mn)
    ''' Space complexity: O(m)
    ''' Where m = length (of the queue) and n = lines.Length
    ''' </summary>
    Function FindInvalidSequence(lines As String(), length As Integer) As Long
        Dim recentValues = New Queue(Of Long)

        For Each line In lines
            Dim value = Long.Parse(line)
            Dim found = recentValues.Count < length

            If Not found Then
                For Each recentValue In recentValues
                    Dim remainder = value - recentValue

                    If recentValues.Contains(remainder) Then
                        found = True
                        Exit For
                    End If
                Next
            End If

            If Not found Then
                Return value
            End If

            recentValues.Enqueue(value)

            If recentValues.Count > length Then
                recentValues.Dequeue()
            End If
        Next

        Throw New InvalidDataException("The list of values is valid!")
    End Function

    ''' <summary>
    ''' Entry point. Reads input from file, find the invalid value and its smallest and largest sum,
    ''' then prints the output.
    ''' </summary>
    Sub Main(args As String())
        Dim lines = File.ReadAllLines("var\aoc9_input.txt")

        Dim invalidValue = FindInvalidSequence(lines, Window)
        Console.WriteLine($"Found invalid value {invalidValue}.")

        Dim sumForInvalidValue = FindSumMatching(lines, invalidValue)
        Console.WriteLine($"Sum of smallest and largest of contiguous values is {sumForInvalidValue}")
    End Sub
End Module
