<p align="center">
    <img src="./public/homeshare2.png" alt="Homeshare Logo">
    <br />
    <br />
    <b>homeshare</b> is a cross-platform application that helps people find and share housing with other people they relate to.
    <br />
    <br />
</p>

<sup>Photo by [Adrian Newell](https://unsplash.com/photos/a-row-of-multicolored-houses-on-a-street-UtfxJZ-uy5Q) on [Unsplash](https://unsplash.com/)</sup>

# Technologies
This app was developed using a combination of modern technologies:
### The Frontend
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)


### The Server & Backend
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)![Express.js](https://img.shields.io/badge/express-%23404d59.svg?style=for-the-badge&logo=express&logoColor=white)![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)![Static Badge](https://img.shields.io/badge/-Postmark-gold?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgd2lkdGg9IjI0MHB4IiBoZWlnaHQ9IjI0MHB4IiBzdHlsZT0ic2hhcGUtcmVuZGVyaW5nOmdlb21ldHJpY1ByZWNpc2lvbjsgdGV4dC1yZW5kZXJpbmc6Z2VvbWV0cmljUHJlY2lzaW9uOyBpbWFnZS1yZW5kZXJpbmc6b3B0aW1pemVRdWFsaXR5OyBmaWxsLXJ1bGU6ZXZlbm9kZDsgY2xpcC1ydWxlOmV2ZW5vZGQiIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4KPGc%2BPHBhdGggc3R5bGU9Im9wYWNpdHk6MSIgZmlsbD0iI2ZlZGQwMCIgZD0iTSAtMC41LC0wLjUgQyA3OS41LC0wLjUgMTU5LjUsLTAuNSAyMzkuNSwtMC41QyAyMzkuNSw3OS41IDIzOS41LDE1OS41IDIzOS41LDIzOS41QyAxNTkuNSwyMzkuNSA3OS41LDIzOS41IC0wLjUsMjM5LjVDIC0wLjUsMTU5LjUgLTAuNSw3OS41IC0wLjUsLTAuNSBaIi8%2BPC9nPgo8Zz48cGF0aCBzdHlsZT0ib3BhY2l0eToxIiBmaWxsPSIjMDMwMjAwIiBkPSJNIDExMi41LDE2NS41IEMgMTE3LjY0LDE2Ni40ODggMTIyLjk3NCwxNjYuODIxIDEyOC41LDE2Ni41QyAxMjguNSwxNzIuMTY3IDEyOC41LDE3Ny44MzMgMTI4LjUsMTgzLjVDIDExMC44MzMsMTgzLjUgOTMuMTY2NywxODMuNSA3NS41LDE4My41QyA3NS41LDE3Ny41IDc1LjUsMTcxLjUgNzUuNSwxNjUuNUMgNzguODQ5OSwxNjUuNjY1IDgyLjE4MzIsMTY1LjQ5OCA4NS41LDE2NUMgODYuMzMzMywxNjQuMTY3IDg3LjE2NjcsMTYzLjMzMyA4OCwxNjIuNUMgODguNjY2NywxMzMuODMzIDg4LjY2NjcsMTA1LjE2NyA4OCw3Ni41QyA4Ny41LDc0LjY2NjcgODYuMzMzMyw3My41IDg0LjUsNzNDIDgxLjUxODQsNzIuNTAyIDc4LjUxODQsNzIuMzM1NCA3NS41LDcyLjVDIDc1LjUsNjYuNSA3NS41LDYwLjUgNzUuNSw1NC41QyA5NC4xNjk2LDU0LjMzMzQgMTEyLjgzNiw1NC41MDAxIDEzMS41LDU1QyAxNjMuNzg1LDU4LjI1NTYgMTc3LjYxOCw3NS43NTU2IDE3MywxMDcuNUMgMTY3LjI2NCwxMjMuMTM4IDE1Ni4wOTcsMTMyLjMwNCAxMzkuNSwxMzVDIDEyOS4yMDcsMTM2LjI2NiAxMTguODc0LDEzNi43NjYgMTA4LjUsMTM2LjVDIDEwOC4zMzQsMTQ1LjE3MyAxMDguNSwxNTMuODQgMTA5LDE2Mi41QyAxMDkuNDIyLDE2NC40MjYgMTEwLjU4OSwxNjUuNDI2IDExMi41LDE2NS41IFoiLz48L2c%2BCjxnPjxwYXRoIHN0eWxlPSJvcGFjaXR5OjEiIGZpbGw9IiNmZGRjMDAiIGQ9Ik0gMTA4LjUsNzQuNSBDIDExNi44NCw3NC4zMzM2IDEyNS4xNzMsNzQuNTAwMyAxMzMuNSw3NUMgMTUwLjI3NSw3OC43MDI0IDE1Ni4xMDgsODguODY5IDE1MSwxMDUuNUMgMTQ3LjA5OSwxMTIuMjA1IDE0MS4yNjYsMTE2LjAzOCAxMzMuNSwxMTdDIDEyNS4xNzMsMTE3LjUgMTE2Ljg0LDExNy42NjYgMTA4LjUsMTE3LjVDIDEwOC41LDEwMy4xNjcgMTA4LjUsODguODMzMyAxMDguNSw3NC41IFoiLz48L2c%2BCjxnPjxwYXRoIHN0eWxlPSJvcGFjaXR5OjEiIGZpbGw9IiM3YjZiMDAiIGQ9Ik0gMTEyLjUsMTY1LjUgQyAxMTguMTY3LDE2NS41IDEyMy44MzMsMTY1LjUgMTI5LjUsMTY1LjVDIDEyOS41LDE3MS44MzMgMTI5LjUsMTc4LjE2NyAxMjkuNSwxODQuNUMgMTExLjMyNiwxODQuODMgOTMuMzI1NiwxODQuNDk3IDc1LjUsMTgzLjVDIDkzLjE2NjcsMTgzLjUgMTEwLjgzMywxODMuNSAxMjguNSwxODMuNUMgMTI4LjUsMTc3LjgzMyAxMjguNSwxNzIuMTY3IDEyOC41LDE2Ni41QyAxMjIuOTc0LDE2Ni44MjEgMTE3LjY0LDE2Ni40ODggMTEyLjUsMTY1LjUgWiIvPjwvZz4KPC9zdmc%2BCg%3D%3D)

### Machine Learning
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)![scikit-learn](https://img.shields.io/badge/scikit--learn-%23F7931E.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)![Pandas](https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white)![Matplotlib](https://img.shields.io/badge/Matplotlib-%23ffffff.svg?style=for-the-badge&logo=Matplotlib&logoColor=black)![TensorFlow](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)![Keras](https://img.shields.io/badge/Keras-%23D00000.svg?style=for-the-badge&logo=Keras&logoColor=white)

---
<br>

This monorepo contains all code for the frontend and backend as well as the Machine Learning models. 

## Navigate
- Frontend [README]()
- Backend [README](./backend/README.md)
- Machine Learning [README]()