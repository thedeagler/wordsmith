extends Node
class_name Utils

static func random_symbol_string(length: int) -> String:
    # var symbols := "!@#$%^&*()_-+=[]{};:'\",.<>?/|\\~` "
    var symbols := "awejf;oaiewjfpap'o30-3 "
    var result := ""
    var rng := RandomNumberGenerator.new()
    rng.randomize()

    for i in length:
        var index := rng.randi_range(0, symbols.length() - 1)
        result += symbols[index]
    return result
