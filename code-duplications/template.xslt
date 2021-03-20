<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />
    <xsl:template match="/">
        <html>

            <head>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous" />
            </head>

            <body>
                <div class="container-fluid">
                    <div class="row">
                        <dif class="col">

                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>
                                            <h1>Estatísticas</h1>
                                        </th>
                                    </tr>
                                </thead>
                                <tr>
                                    <td>
                                        Tamanho total da base de código:
                                        <xsl:value-of select="//CodebaseCost" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Tamanho do código que deve ser analisado:
                                        <xsl:value-of select="//TotalDuplicatesCost" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Tamano total dos fragmentos duplicados:
                                        <xsl:value-of select="//TotalFragmentsCost" />
                                    </td>
                                </tr>
                            </table>

                            <h1>Duplicações detectadas</h1>
                            <xsl:for-each select="//Duplicates/Duplicate">
                                <hr />

                                <div class="row">

                                    <div class="col-12">
                                        <h3>
                                            Tamanho do código duplicado:
                                            <xsl:value-of select="@Cost" />
                                        </h3>
                                    </div>
                                    <div class="col-12">
                                        <h4>Fragmentos Duplicados:</h4>
                                    </div>

                                    <xsl:for-each select="Fragment">
                                        <xsl:variable name="i" select="position()" />

                                        <div class="col-6">

                                            <p>
                                                <div class="d-inline">
                                                    Fragmento
                                                    <xsl:value-of select="$i" />
                                                    :
                                                </div>

                                                <div class="text-break font-weight-bold d-inline">
                                                    <xsl:value-of select="FileName" />
                                                </div>
                                                <div>
                                                    Linhas
                                                    <xsl:value-of select="LineRange/@Start" />
                                                    á
                                                    <xsl:value-of select="LineRange/@End" />
                                                </div>
                                            </p>

                                            <pre class="text-light bg-dark p-2">
                                                <xsl:value-of select="Text" />
                                            </pre>

                                        </div>

                                    </xsl:for-each>
                                </div>

                            </xsl:for-each>

                        </dif>
                    </div>

                </div>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
