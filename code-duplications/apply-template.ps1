function process-XSLT {
    param([string]$a)

    $xsl = join-path $pwd "template.xslt"
    $inputstream = new-object System.IO.MemoryStream
    $xmlvar = new-object System.IO.StreamWriter($inputstream)
    $xmlvar.Write("$a")
    $xmlvar.Flush()
    $inputstream.position = 0
    $xml = new-object System.Xml.XmlTextReader($inputstream)
 
    $output = New-Object System.IO.MemoryStream
    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
    $arglist = new-object System.Xml.Xsl.XsltArgumentList
    $reader = new-object System.IO.StreamReader($output)
    $xslt.Load($xsl)
    $xslt.Transform($xml, $arglist, $output)
    $output.position = 0
 
    $transformed = [string]$reader.ReadToEnd()
    $reader.Close()
    return $transformed
}

$inputPath = join-path $pwd "reports\duplications.xml"
$outputPath = join-path $pwd "reports\duplications-report.html"

if (Test-Path $outputPath) 
{
    Remove-Item $outputPath
}

$inputText = [System.IO.File]::ReadAllText($inputPath)

$text = process-XSLT $inputText

[System.IO.File]::WriteAllText($outputPath, $text);