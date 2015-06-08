
// 用宏来定义一个单利

// .h
#define single_interface(class)     + (class *)share##class;

// .m
#define single_implementation(class)                  \
static class *_singleAccount = nil;                       \
                                                                            \
+ (class *)share##class                                        \
{ \
    if (_singleAccount == nil) {   \
        _singleAccount = [[self alloc]init];  \
    } \
    return _singleAccount; \
}  \
 \
+ (id)allocWithZone:(struct _NSZone *)zone  \
{  \
    static dispatch_once_t onceToken;  \
    dispatch_once(&onceToken, ^{   \
        _singleAccount = [super allocWithZone:zone];  \
    });  \
    return _singleAccount;  \
}     // 最后不要写 \   