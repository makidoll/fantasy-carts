#include <cstdio> 
#include <cstdlib> 
#include <fstream> 
#include "geometry.h" 
#include "vertexdata.h" 
 
void setProjectionMatrix(const float &angleOfView, const float &near, const float &far, Matrix44f &M) 
{ 
    // set the basic projection matrix
    float scale = 1 / tan(angleOfView * 0.5 * M_PI / 180); 
    M[0][0] = scale; // scale the x coordinates of the projected point 
    M[1][1] = scale; // scale the y coordinates of the projected point 
    M[2][2] = -far / (far - near); // used to remap z to [0,1] 
    M[3][2] = -far * near / (far - near); // used to remap z [0,1] 
    M[2][3] = -1; // set w = -z 
    M[3][3] = 0; 
} 
 
void multPointMatrix(const Vec3f &in, Vec3f &out, const Matrix44f &M) 
{ 
    //out = in * M;
    out.x   = in.x * M[0][0] + in.y * M[1][0] + in.z * M[2][0] + /* in.z = 1 */ M[3][0]; 
    out.y   = in.x * M[0][1] + in.y * M[1][1] + in.z * M[2][1] + /* in.z = 1 */ M[3][1]; 
    out.z   = in.x * M[0][2] + in.y * M[1][2] + in.z * M[2][2] + /* in.z = 1 */ M[3][2]; 
    float w = in.x * M[0][3] + in.y * M[1][3] + in.z * M[2][3] + /* in.z = 1 */ M[3][3]; 
 
    // normalize if w is different than 1 (convert from homogeneous to Cartesian coordinates)
    if (w != 1) { 
        out.x /= w; 
        out.y /= w; 
        out.z /= w; 
    } 
} 
 
int main(int argc, char **argv) 
{ 
    uint32_t imageWidth = 512, imageHeight = 512; 
    Matrix44f Mproj; 
    Matrix44f worldToCamera; 
    worldToCamera[3][1] = -10; 
    worldToCamera[3][2] = -20; 
    float angleOfView = 90; 
    float near = 0.1; 
    float far = 100; 
    setProjectionMatrix(angleOfView, near, far, Mproj); 
    unsigned char *buffer = new unsigned char[imageWidth * imageHeight]; 
    memset(buffer, 0x0, imageWidth * imageHeight); 
    for (uint32_t i = 0; i < numVertices; ++i) { 
        Vec3f vertCamera, projectedVert; 
        multPointMatrix(vertices[i], vertCamera, worldToCamera); 
        multPointMatrix(vertCamera, projectedVert, Mproj); 
        if (projectedVert.x < -1 || projectedVert.x > 1 || projectedVert.y < -1 || projectedVert.y > 1) continue; 
        // convert to raster space and mark the position of the vertex in the image with a simple dot
        uint32_t x = std::min(imageWidth - 1, (uint32_t)((projectedVert.x + 1) * 0.5 * imageWidth)); 
        uint32_t y = std::min(imageHeight - 1, (uint32_t)((1 - (projectedVert.y + 1) * 0.5) * imageHeight)); 
        buffer[y * imageWidth + x] = 255; 
    } 
    // save to file
    std::ofstream ofs; 
    ofs.open("./out.ppm"); 
    ofs << "P5\n" << imageWidth << " " << imageHeight << "\n255\n"; 
    ofs.write((char*)buffer, imageWidth * imageHeight); 
    ofs.close(); 
    delete [] buffer; 
 
    return 0; 
} 