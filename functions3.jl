#######################################
# Functions used in workbook three
#######################################


# Function that returns the derivative of f(x)=sin(exp(x)) at a value of x and a given step size h
function derivsinexp(x,h)
    deriv=(-BigFloat(3)*sin(exp(x))+BigFloat(4)*sin(exp(x+h))-sin(exp(x+BigFloat(2)*h)))/(BigFloat(2)*h)
    return(deriv)
end

