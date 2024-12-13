function Get-UrlEncodedCharacter {
    param (
        [char]$Character
    )

    # Get the ASCII value of the character
    $asciiValue = [int][char]$Character

    # Convert the ASCII value to its hexadecimal representation and format it as a URL encoded value
    $encodedCharacter = '%' + [System.Convert]::ToString($asciiValue, 16).ToUpper()

    return $encodedCharacter
}

function Encode-AllCharacters {
    param (
        [string]$InputString
    )

    # Encode each character in the input string
    $encodedString = -join ($InputString.ToCharArray() | ForEach-Object { Get-UrlEncodedCharacter -Character $_ })

    return $encodedString
}

function Get-SecretSanta {
    param (
        [string[]]$Names,
        [string]$Message
    )

    # Create a hashtable to store the Secret Santa assignments
    $secretSantaAssignments = @{}

    do {
        # Shuffle the names array
        $shuffledNames = $Names | Get-Random -Count $Names.Length

        # Check if any giver is the same as the receiver
        $validAssignment = $true
        for ($i = 0; $i -lt $Names.Length; $i++) {
            if ($Names[$i] -eq $shuffledNames[$i]) {
                $validAssignment = $false
                break
            }
        }
    } while (-not $validAssignment)

    # Encode Message:
    $Message = Encode-AllCharacters -InputString $Message

    # Assign Secret Santas
    for ($i = 0; $i -lt $Names.Length; $i++) {
        $giver = $Names[$i]
        $receiver = $shuffledNames[$i]

        # Encode every character in the receiver's name
        $encodedReceiver = Encode-AllCharacters -InputString $receiver

        # Create the Google search link with the encoded 'q' parameter
        $googleSearchLink = "https://www.google.com/search?q=$Message$encodedReceiver"

        # Add the assignment to the hashtable
        $secretSantaAssignments[$giver] = $googleSearchLink
    }

    # Convert the hashtable to a JSON object
    $jsonResult = $secretSantaAssignments | ConvertTo-Json -Depth 3

    return $jsonResult
}

# Example usage
$names = @("Sandra", "Oskar", "Meggie", "Pontus", "Eva", "Ivan", "Ingrid")
$jsonResult = Get-SecretSanta -Names $names -Message "Du ska köpa julklapp till: "
Write-Output $jsonResult
